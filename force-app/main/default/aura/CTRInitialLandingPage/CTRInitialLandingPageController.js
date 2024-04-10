({
	doInit : function(component, event, helper) 
    {
        
        var recordId = component.get("v.recordId");
        
        if(recordId == null || recordId == '')
        {
            var recordTypeId = component.get("v.pageReference").state.recordTypeId;
            console.log('recordTypeId---'+recordTypeId);
            component.set('v.recordTypeId',recordTypeId);

            var action = component.get("c.getAccountRecordTypeInitial");
            action.setParams({"RecordId": recordTypeId});
            //action.setParams({"RecordId": recordTypeId});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") 
                {
                    var result = response.getReturnValue();
                    if(result.allowOpenForActor == true)
                    {
                        if(result.mRecordTypeId == recordTypeId)
                        {
                            try
                            {
                                //component.set("v.userProfile",'System Administrator');
                                
                                var actiongetUserRole = component.get("c.getUserInfomation");
                                
                                console.log('actiongetUserRole--'+actiongetUserRole);
                                actiongetUserRole.setCallback(this, function(responseGetUser) 
                                {
                                    var state = responseGetUser.getState();
                                    console.log('state-2--'+state);
                                    if (state === "SUCCESS") 
                                    {
                                        var userInfo = responseGetUser.getReturnValue();
                                        
                                        console.log('userInfo.Profile.name-23--'+userInfo);
                                        //console.log('userInfo.Profile.name-23--'+userInfo.BusinessUnit__c); 
                                        //component.set("v.userProfile",userInfo.Profile.Name);
                                        
                                        var modalBody; 
                                        var modalFooter;
                                        $A.createComponents([
                                                                [('c:CTRInitialCustomerTOP'),
                                                                        {isInitial:true 
                                                                        ,recordTypeId:component.get("v.recordTypeId")
                                                                        ,ObjectType:component.get("v.ObjectType")
                                                                        ,onPageRecordID : component.get("v.recordId")
                                                                        ,recordId : component.get("v.recordId")}]
                                                            ],
                                                            function(components, status){
                                                                if (status === 'SUCCESS') {
                                                                    modalBody = components[0];
                                                                    component.find('overlayLib').showCustomModal({
                                                                        header: 'New Customer: Initial',
                                                                        body: modalBody,
                                                                        footer: modalFooter,
                                                                        showCloseButton: true,
                                                                        cssClass: 'my-modal,my-custom-class,my-other-class, mymodal slds-modal_large',
                                                                        closeCallback: function() {
                                                                        }
                                                                    });
                                                                }
                                                            });
                                        
                                    }
                                    else
                                    {     
                                        var navigateToURL;
                                        console.log('recordTypeId-2--'+recordTypeId);
                                        //navigateToURL = "/lightning/o/Account/new?&defaultFieldValues=recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                        navigateToURL = "/lightning/o/Account/new?&recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                                        var urlEvent = $A.get("e.force:navigateToURL");
                                        urlEvent.setParams({
                                            "url": navigateToURL
                                        });
                                        urlEvent.fire();
                                        
                                    }
                                });
                                $A.enqueueAction(actiongetUserRole);
                            }
                            catch(ex)
                            {
                                console.log('ex--'+ex.message());
                            }
                    
                    
                        }
                        else
                        {     
                            var navigateToURL;
                            console.log('recordTypeId-2--'+recordTypeId);
                            //navigateToURL = "/lightning/o/Account/new?&defaultFieldValues=recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                            navigateToURL = "/lightning/o/Account/new?&recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                            var urlEvent = $A.get("e.force:navigateToURL");
                            urlEvent.setParams({
                                "url": navigateToURL
                            });
                            urlEvent.fire();
                            
                        }
                    }
                    else
                    {
                        helper.toastEvent('Error','Do not have permission','error');
                        var navigateToURL;
                        navigateToURL = '/lightning/o/Account/list?filterName=Recent';
                        var urlEvent = $A.get("e.force:navigateToURL");
                        urlEvent.setParams({
                            "url": navigateToURL
                        });
                        urlEvent.fire();
                    }
                }
            });
            $A.enqueueAction(action);
            
            /*else
            {     
                var navigateToURL;
                console.log('recordTypeId-2--'+recordTypeId);
                //navigateToURL = "/lightning/o/Account/new?&defaultFieldValues=recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                navigateToURL = "/lightning/o/Account/new?&recordTypeId="+recordTypeId+"&backgroundContext=%2Flightning%2Fo%2FAccount%2Flist%3FfilterName%3DRecent"+"&nooverride=1";
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": navigateToURL
                });
                urlEvent.fire();
                
            }*/
        }
        else
        {
            //Edit RequestForm Header Record
            try
            {
                component.set("v.ObjectType",'CTRRequestFormHeader__c');
                var action = component.get("c.getReqItemInfo");
                action.setParams({
                    "itemId": recordId
                });
                
                action.setCallback(this, function(response) {
                    var state = response.getState();
                    
                    if (state === "SUCCESS") 
                    {
                        var itemInfo = response.getReturnValue();
                        if(itemInfo.Customer__r.AccountNumber != '' || itemInfo.Customer__r.AccountNumber != null)
                        {
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "title": "Error!",
                                "message": "Cannot Edit! There is another request in proceeded",
                                "type" : "error"
                            });
                            toastEvent.fire();
                        }
                        else
                        {
                            
                            
                        }
                        
                    }
                }
                );
                $A.enqueueAction(action);
                
                
            }
            catch(ex)
            {
                console.log('ex----'+ex.message());
            }
            
            
            
            
        }
        
		
	},
    onPageReferenceChanged: function(cmp, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleCancel : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
          "url": "/lightning/o/Account/list?filterName=Recent"
        });
        urlEvent.fire();
    }
})