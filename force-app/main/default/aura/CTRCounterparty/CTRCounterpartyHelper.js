({
	createObjectData: function(component, event, helper) {
        // get the contactList from component and add(push) New Object to List
        var itemList = component.get("v.itemList");

        itemList.push('test');

        // set the updated list to attribute (contactList) again
        component.set("v.itemList", itemList);
    },

    getReqItemInfo : function(component) {
        component.set('v.isLoaded', false);
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
                console.log('item.Customer__c-counter-'+item.CTRRequestFormHeader__c);
                
                component.set("v.headerId",item.CTRRequestFormHeader__c);
                console.log('item.RecordType.DeveloperName: '+item.RecordType.DeveloperName);
                if(item.RecordType.DeveloperName.includes('Customer'))
                {
                    console.log('customer');

                    component.set('v.isCustomerType', true);
                }
                else if(item.RecordType.DeveloperName.includes('Supplier'))
                {
                    console.log('supplier');

                    component.set('v.isSupplierType', true);
                }
                if(item.RecordType.DeveloperName.includes('Initial') || item.RecordType.DeveloperName.includes('Extend'))
                {
                    if(component.get('v.currentUserProfileName') == 'System Administrator')
                    {
                        component.set('v.DisplayEditButton', true);
                    }
                    else if((item.Status__c == 'New' && item.isOwner__c == true) ||
                    (item.Status__c == 'In Review' && item.Approval_Step__c == 'Verify Documents' && item.ApprovedChangeCounterparty__c != 'Submitted' && (item.IsCreditOwner__c == true || item.DocumentChecklistButton__c == true)))
                    {
                        component.set('v.DisplayEditButton', true);
                    }
                }
                //var recordTypeName = item.RecordType.DeveloperName;
                //console.log('recordTypeNamec--'+recordTypeName);
                //
                /*
                if(recordTypeName == 'CustomerInitial' || recordTypeName == 'SupplierInitial')
                {
                    component.set("v.onPageRecordID",item.Customer__c);
                }
                else
                {
                    component.set("v.onPageRecordID",recordId);
                }*/
                //console.log('recordTypeNamec--'+component.get("v.onPageRecordID"));
                
            }
            
        });
        $A.enqueueAction(action);
    },

    getUserName : function(component) {
        console.log('[getUserName] -----'+component.get('v.getUserName'));
        component.set('v.isLoaded', false);
        var action = component.get("c.getCurrentUserName");
        action.setParams({
            "userId": $A.get("$SObjectType.CurrentUser.Id")
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result)
                {
                    
						component.set('v.currentUserName', result.Name);
                        component.set('v.currentUserProfileName', result.Profile.Name);
                    console.log(component.get('v.currentUserName'));
                    console.log(component.get('v.currentUserProfileName'));
                }
                
                
                console.log('result -----', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[getUserName] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[getUserName] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    validateUserProfile : function(component) {
        console.log('[validateUserProfile] -----'+component.get('v.recordId'));
        component.set('v.isLoaded', false);
        var action = component.get("c.validateUserProfile");
        action.setParams({
            "userId": $A.get("$SObjectType.CurrentUser.Id"),
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var result = response.getReturnValue();
                if(result)
                {
                    console.log('isTX: '+ result.BusinessUnit__c);
                     //component.set('v.isTOP', true);
                     //component.set('v.isTX', true);
                    if(result.BusinessUnit__c == 'TX')
                    {
                        component.set('v.isTX', true);
                    }
					else
					{
						component.set('v.isTOP', true);
					}
                }
                
                
                console.log('result -----', result);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log('[validateUserProfile] error -----', errors[0].message);
                        this.showToast('Error', 'error', errors[0].message);
                    }
                } else {
                    console.log('[validateUserProfile] unknown error -----');
                    this.showToast('Error', 'error', 'Unknown error');
                }
            }
            component.set('v.isLoaded', true);
        });
        $A.enqueueAction(action);
    },

    checkItem : function(component, event, helper) {
        
        console.log('recordId---'+component.get('v.recordId'));
        var recordId = component.get('v.recordId');
        var action = component.get("c.getReqItemInfo");
        action.setParams({
            "itemId": recordId
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") 
            {
                var itemInfo = response.getReturnValue();
                console.log("itemInfo.Customer__c---"+itemInfo.Customer__c);
                
                // if((itemInfo.Customer__r.AccountNumber__c != '' && itemInfo.Customer__r.AccountNumber__c != null) || (itemInfo.Customer__r.SupplierNumber__c != '' && itemInfo.Customer__r.SupplierNumber__c != null))
                // {
                //     var toastEvent = $A.get("e.force:showToast");
                //     toastEvent.setParams({
                //         "title": "Error!",
                //         "message": "Cannot Edit! This counter party already has SAP Number",
                //         "type" : "error"
                //     });
                //     toastEvent.fire();
				// 	$A.get("e.force:closeQuickAction").fire();
                // }

                // else
                // {
                    if(itemInfo.Status__c == 'In Review')  
                    {
                        if(itemInfo.isTRCR__c == 'true')
                        {
                            if(itemInfo.CTRRequestFormHeader__r.ApprovedChangeCounterparty__c != 'Submitted')
                            {
                                console.log("headerId---"+component.get("v.headerId"));
                                component.set('v.IsPageDisable',false);
                            }
                            else
                            {
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Cannot Edit! There is other request in Submit Change to TRCR Section head.",
                                    "type" : "error"
                                });
                                toastEvent.fire();
                                component.set('v.IsPageDisable',false);
                                $A.get("e.force:closeQuickAction").fire();
                            }
                        }
                        
                        else
                        {
                            var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "title": "Error!",
                                    "message": "Cannot Edit! In Review Stage only allow TRCR to Edit Counter Party",
                                    "type" : "error"
                                });
                                toastEvent.fire();
                                component.set('v.IsPageDisable',false);
                                $A.get("e.force:closeQuickAction").fire();
                        }
                    }
                    else
                    {
                        //component.set('v.IsPageDisable',false);
                        var actionInReview = component.get("c.getItemEachStage");
                        actionInReview.setParams({
                            "accId": itemInfo.Customer__c,
                            "Stage": "InReview"
                        });
                        
                        actionInReview.setCallback(this, function(responseInReview) {
                            var stateInReview = responseInReview.getState();
                            console.log("stateInReview---"+stateInReview);
                            console.log("responseInReview.getReturnValue()---"+JSON.stringify(responseInReview.getReturnValue()));
                            if (stateInReview === "SUCCESS") 
                            {
                                var itemInfo = responseInReview.getReturnValue();
                                console.log("itemInfo.lenght()---"+itemInfo.length);
                                var inreview = itemInfo.length;
                                if(inreview > 0)
                                {
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "title": "Error!",
                                        "message": "Cannot Edit! There is other request in review stage.",
                                        "type" : "error"
                                    });
                                    toastEvent.fire();
                                    component.set('v.IsPageDisable',false);
                                    $A.get("e.force:closeQuickAction").fire();
                                }
                                else
                                {
                                    console.log("headerId---"+component.get("v.headerId"));
                                    component.set('v.IsPageDisable',false);
                                    
                                    /*$A.createComponent("c:CTRInitialCustomerTOP", { 
                                        "isInitial": true, 
                                        "ObjectType": 'CTRRequestFormHeader__c',
                                        "onPageRecordID": component.get("v.headerId"),
                                        "recordId": component.get("v.headerId")
                                    }, function(newCmp) {
                                        if (component.isValid()) {
                                            component.set("v.body", newCmp);
                                            console.log('v.body---'+component.get("v.body"));
                                        }
                                    });*/
                                    /*$A.createComponents([
                                        [(userInfo.Profile.Name == 'TOP' || userInfo.Profile.Name == 'System Administrator' ? 'c:CTRInitialCustomerTOP':'c:CTRInitialCustomerTX'),{isInitial:true 
                                                                    ,recordTypeId:component.get("v.recordTypeId")
                                                                    ,ObjectType:'CTRRequestFormHeader__c'
                                                                    ,onPageRecordID : component.get("v.headerId")
                                                                    ,recordId : component.get("v.headerId")}]
                                    ],
                                                        function(components, status){
                                                            if (status === 'SUCCESS') {
                                                                modalBody = components[0];
                                                                component.find('overlayLib').showCustomModal({
                                                                    header: 'Edit counter party',
                                                                    body: modalBody,
                                                                    footer: modalFooter,
                                                                    showCloseButton: true,
                                                                    cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                                    closeCallback: function() {
                                                                    }
                                                                });
                                                            }
                                                        });*/
                                }
                                
                            }
                        }
                                        );
                        $A.enqueueAction(actionInReview);
                    }
                    
                //}
                
            }
        }
                          );
        $A.enqueueAction(action);
    },

    showToast : function(title, type, message) {
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			"title": title,
			"type": type,
			"message": message
		});
		toastEvent.fire();
	},
})