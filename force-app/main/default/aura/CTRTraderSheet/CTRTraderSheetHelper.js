({
	getRequestItems : function(component, event, recordId) 
    {
        console.log('---getRequestItems---');
		var action = component.get("c.getRequestFormItem");
        action.setParams({
            "recID": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                try
                {
                    var requestList = response.getReturnValue();
                    var AgreeRegisterCustomer = requestList[0].AgreeRegisterCustomer__c;
                    var ResultFromNewsScreening = requestList[0].ResultFromNewsScreening__c;
                    var Link = requestList[0].LinkToNEWS__c;
                    var TraderApproved = requestList[0].TraderPreScreenDecision__c;
                    var SHApproved = requestList[0].SHPrescreenDecision__c;
                    var CMVPApproved = requestList[0].CMVPPreScreenDecision__c;
                    var CurrentApprover = requestList[0].CurrentApprover__c;
                    var HeadName = requestList[0].OwnersSectionHead__c;
                    var VPName = requestList[0].OwnersCMVP__c;
                    var TraderName = requestList[0].OwnerId;
                    var CurrentUser = component.get("v.CurrentUserID");
                    var IsDeclareCheck = requestList[0].DeclareTheInformation__c;
                    var RecordTypeName = requestList[0].RecordType.DeveloperName;
                    var CustomerPurchaseProductFrom = requestList[0].CTRRequestFormHeader__r.CustomerPurchaseProductFrom__c;
                    var LegalEntity = requestList[0].CTRRequestFormHeader__r.LegalEntity__c;
                    var TypeOfBusinessEva = requestList[0].CTRRequestFormHeader__r.TypeOfBusinessCommercialEvaluation__c;
                    var Thelevelofreputation = requestList[0].Thelevelofreputation__c;
                    var itemstatus = requestList[0].Status__c;
                    var commercialscoring = requestList[0].CommercialScoringResult__c;
                    var ctruser = requestList[0].CTRRequestFormHeader__r.Customer__r.CTRUser__c;
                    var ApprovalStep = requestList[0].Approval_Step__c;
                    var PositionNameOfVP = requestList[0].fmlPositionNameOfVP__c;
                    console.log('---ctruser---'+ctruser);
                    console.log('---ApprovalStep---'+ApprovalStep);
                    console.log('---PositionNameOfVP---'+PositionNameOfVP);
                console.log('---commercialscoring---'+commercialscoring);
                
                
                component.set('v.CTRUserId',ctruser);
                
                console.log('---OwnerId---'+component.get('v.StatusPass'));
                    console.log('---OwnerId---'+requestList[0].OwnerId);
                    //set value
                    component.set('v.TypeOfBusinessEva',TypeOfBusinessEva);
                    component.set('v.CurrentApprover',CurrentApprover);
                    component.set('v.TraderApproved',TraderApproved);
                    component.set('v.HeadName',HeadName);
                    component.set('v.VPName',VPName);
                    component.set('v.TraderName',TraderName);
                    component.set('v.IsDeclareCheck',IsDeclareCheck);
                    if(RecordTypeName.includes('Customer'))
                    {
                     component.set('v.RecordTypeName','Customer');   
                    }
                    else
                    {
                        component.set('v.RecordTypeName','Supplier');
                    }
                    
                    component.set('v.CustomerPurchaseProductFrom',CustomerPurchaseProductFrom);
                    component.set('v.LegalEntity',LegalEntity);
                    component.set('v.ReputationMarket',Thelevelofreputation);  
                    component.set('v.PositionNameOfVP',PositionNameOfVP); 
                    
                    console.log('---TraderName---'+component.get('v.TraderName'));
                console.log('---CurrentApprover---'+CurrentApprover);
                
                if(CurrentApprover == 'Trader')
                {
                    component.set('v.CurrentApproverId',TraderName);
                    if(itemstatus == 'Pre Screen')  //&& commercialscoring != null && commercialscoring != undefined 
                    {
                        component.set('v.StatusPass',true);
                    }
                }
                else if(CurrentApprover == 'Head')
                {
                    component.set('v.CurrentApproverId',HeadName);
                    if(itemstatus == 'In Review' && ApprovalStep == 'Review Pre-Screen')
                    {
                        component.set('v.StatusPass',true);
                    }
                }
                else if(CurrentApprover == 'VP')
                {
                    component.set('v.CurrentApproverId',VPName);
                    if(itemstatus == 'In Review' && ApprovalStep == 'Review Pre-Screen')
                    {
                        component.set('v.StatusPass',true);
                    }
                }
                console.log('---isEnableButtonHead---'+component.get('v.isEnableButtonHead'));    
                    
                    if(IsDeclareCheck)
                    {
                        component.set('v.CanSubmitted',true);
                    }
                    
                    //#4
                    console.log('---=======1===ResultFromNewsScreening==---'+ResultFromNewsScreening);
                    if(ResultFromNewsScreening != null)
                    {
                        /*
                        if(ResultFromNewsScreening == "No compliance risk news")
                            component.find("NoCompliance").getElement().checked = true;
                        else if(ResultFromNewsScreening == "Has compliance risk news (please specify)")
                            component.find("HasCompliance").getElement().checked = true;*/
                        
                        if(ResultFromNewsScreening == 'Has compliance risk news (please specify)')
                        {
                            component.set('v.HasRiskNews',true);
                        }
                        else
                        {
                            component.set('v.HasRiskNews',false);
                        }
                    }
                    console.log('---=======1=====-AgreeRegisterCustomer--'+AgreeRegisterCustomer);
                    //#7
                    if(AgreeRegisterCustomer != null)
                    {
                        /*
                        if(AgreeRegisterCustomer == "Yes")
                            component.find("Yes-4").getElement().checked = true;
                        else if(AgreeRegisterCustomer == "No")
                            component.find("No-4").getElement().checked = true;*/
                        
                        if(AgreeRegisterCustomer == 'No')
                        {
                            component.set('v.IsDisagreement',true);
                        }
                        else
                        {
                            component.set('v.IsDisagreement',false);
                        }
                    }
                    console.log('---=======2=====---'+Link);
                    
                    //setup link
                    component.set("v.LinktoNews",Link);
                    
                    console.log('---=======3=====---');
                    
                    //Render section
                    console.log('---TraderApproved---'+TraderApproved);
                    console.log('---SHApproved---'+SHApproved);
                    console.log('---CMVPApproved---'+CMVPApproved);
                    if(TraderApproved != '' && CurrentApprover == 'Head')
                    {
                        component.set('v.IsPageDisable',true);
            			component.set('v.IsSubmitted',true);
                        
                    }
                    if(SHApproved != '' && CurrentApprover == 'VP')
                    {
                        //show SectionHead Approval
                        component.set('v.IsSubmitted',true);
                        component.set('v.IsSectionHeadApproved',true);
                        
                    }
                    if(CMVPApproved != '' && CurrentApprover == 'Done')
                    {
                        component.set('v.IsSubmitted',true);
                        component.set('v.IsSectionHeadApproved',true);
                        component.set('v.IsCMVPApproved',true);
            			component.set('v.IsButtonDisable',true);
                        
                        
                    }
                    
                    
                    console.log('---=======HeadName=====---'+HeadName);
                    console.log('---=======VPName=====---'+VPName);
                    console.log('---=======CurrentUser=====---'+CurrentUser);
                    console.log('---=======CurrentApprover=====---'+CurrentApprover);
                    /*
                    var cmpTarget = component.find('SHPreScreenComment__c');
                    console.log('---=======cmpTarget=====---'+cmpTarget);
                    $A.util.removeClass(cmpTarget, 'slds-textarea');
                    $A.util.addClass(cmpTarget, 'comment');*/
                    //let elements = document.getElementsByName("SHPreScreenComment__c");
					//console.log('---=======elements=====---'+elements);
                }
                catch(ex)
                {
                    console.error('---======Error===---'+ex.message);
                }
                    
                    /*if((CurrentApprover == 'Head' && CurrentUser !=  HeadName)) // || (CurrentApprover == 'VP' && CurrentUser !=  VPName)
                    {
                        //Disable edit button
                        console.log('---=======Disable edit button=====---');
                        component.set('v.IsButtonDisable',false);
                    }*/
                    
                    
                //}
                
            }
        }
        );
        $A.enqueueAction(action);
        //$A.get('e.force:refreshView').fire();
	},
    getShippingCountry : function(component, event, recordId) 
    {
        console.log('---getShippingCountry---'+recordId);
		var action = component.get("c.getShippingCountry");
        action.setParams({
            "recordId": recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") 
            {
                var requestList = response.getReturnValue();
                console.log('---requestList---'+requestList);
                if(requestList != '')
                {
                    component.set("v.ShippingCountry",requestList);
                }
            }
        }
        );
        $A.enqueueAction(action);
	},
    /*
    getCurrentUserName : function(component, event, recordId) 
    {
        try
        {
            console.log('---getCurrentUserName---');
            var action = component.get("c.getUserInfomation");
            action.setParams({
                "recordId": recordId
            });
            action.setCallback(this, function(response){
                console.log('---response--2-');
                
                console.log('---response---'+response);
                var state = response.getState();
                console.log('---state---'+state);
                
                if (state == "SUCCESS") {
                    var uInfo = response.getReturnValue();
                    console.log('---test1---');
                    console.log('---CurrentUser---'+JSON.stringify(response.getReturnValue()));
                   // component.set("v.CurrentUserName",uInfo.Name);
                    component.set("v.CurrentUserID",$A.get("$SObjectType.CurrentUser.Id"));
                    console.log('---CurrentUserID---'+uInfo.Id);
                    
                    
                }
            }
                              );
            $A.enqueueAction(action);
        }
        catch(ex)
        {
            console.log('---ex---'+JSON.stringtify(ex));
        }
        
	},*/
    getBUInfo : function(component, event, recordId) 
    {
        try
        {
            console.log('---getBUInfo---');
            var action = component.get("c.getBUInfo");
            action.setParams({
                "recordId": component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                
                var state = response.getState();
                console.log('---state--getbu-'+state);
                
                if (state == "SUCCESS") {
                    var uInfo = response.getReturnValue();
                    component.set("v.BUInfo",uInfo);
                }
                else
                {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            // log the error passed in to AuraHandledException
                            console.log("Error message: " + 
                                        errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            }
                              );
            $A.enqueueAction(action);
        }
        catch(ex)
        {
            console.log('---ex---'+JSON.stringtify(ex));
        }
        
	}
    
    
})