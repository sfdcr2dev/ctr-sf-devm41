({
    doInit : function(component, event, helper) 
    {
        console.log('do init');

        var recordId = component.get("v.recordId");        
        var action = component.get("c.getDefaultData"); 
        action.setParams({recordId: recordId});
        console.log('before apex');

        action.setCallback(this, function(response) 
        {
            var state = response.getState();
            console.log('state: '+state);

            if (state === 'SUCCESS') 
            {
                var result = response.getReturnValue();
                console.log('result:'+JSON.stringify(result));
                console.log('result:'+result.mResult);

                if(result.mResult.includes('Success'))
                {
                    console.log('result success:'+result.mRecordTypeName);

                    //var mToken = result.mToken;
                    var mHeader = result.mRequestHeader;
                    var mItem = result.mRequestItem;
                    //component.set('v.mToken', mToken);
                    component.set('v.mRequestItem', mItem);
                    component.set('v.mRequestHeader', mHeader);

                    console.log('mRequestHeader:'+JSON.stringify(mHeader));

                    if(result.mRecordTypeName.includes('Initial') || result.mRecordTypeName.includes('Extend'))
                    {
                        console.log('result:'+result.mRecordTypeName);
                        console.log('result:'+result.SAPStatus__c);
                        //console.log('initial'+result.mGeneralViewCreated);
                        if(result.mRecordTypeName.includes('Initial'))
                        {
                            component.set("v.isInitial", true);
                        }
                        if((result.mRecordTypeName.includes('Customer') && !result.mAccountNumber) || 
                        (result.mRecordTypeName.includes('Supplier') && !result.mSupplierNumber))
                        {
                            console.log('no gen');
                            
                            var validatemessage = helper.validateRequiredFieldHelper(mHeader, mItem, component.get("v.mainComponentName"));
                            if(result.mRecordTypeName.includes('Extend'))
                            {
                                component.set('v.DynamicText', 'Inintial Process is not finished yet. Please recheck your SAP Number before Extend');
                                component.set("v.AllowSend", false);

                            }
                            else 
                            {
                                if(validatemessage[0] == 'ByPass')
                                {
                                    component.set('v.mDataReady', true);
                                    component.set("v.AllowSend", true);
                                    
                                }
                                else
                                {
                                    component.set("v.AllowSend", false);
                                    component.set('v.mValidateMessageList', validatemessage);
                                    console.log('data blank');
                                }
                            }
                            component.set("v.isGeneralSent", false);

                        }
                        else
                        {
                            console.log(' gen');
                            //if(component.get("v.mainComponentName") == 'Customer')
                           if(result.mRecordTypeName.includes('Customer'))
                            {
                                if(!mItem.SAPNumber__c)
                                {
                                    
                                    //console.log(' gen1'+ mItem.Customer__r.AccountNumber__c);
                                    if(mItem.SAPStatus__c == 'Send General View To SAP')
                                    {
                                        console.log(' gen2');
                                        component.set('v.DynamicText', 'Sending General view to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                    else if(mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.SAPCCAMapped__c == true)
                                    {
                                        component.set('v.DynamicText', 'General View has been sent. And CCA has mapped to Salesforce. do you confirmed sales view data before submit again?');
                                        component.set("v.AllowSend", true);
                                        component.set("v.ConfirmButtonName", "Confirm")
                                    }
                                    else if(mItem.SAPStatus__c == 'SAP Confirmed General View' || 
                                    (mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.SAPCCAMapped__c == false) || mItem.Customer__r.AccountNumber__c)
                                    {
                                        console.log(' gen3');
                                        if(result.mQueue == 0)
                                        {
                                            component.set('v.DynamicText', 'General View has been sent. Do you want to inform SAP to mapping CCA and Send Sales data?');
                                            component.set("v.AllowSend", true);
                                            component.set("v.ConfirmButtonName", "Inform CCA")
                                        }
                                        else
                                        {
                                            component.set('v.DynamicText', 'Account Number: '+mItem.Customer__r.AccountNumber__c+' Sales Organization number '+mItem.SalesOrganization__c+' is waiting for mapping CCA for '+result.mQueue+' record(s). Do you want to pending queue to inform mapping CCA?' );
                                            component.set("v.AllowSend", true);
                                            component.set("v.ConfirmButtonName", "Queue to Inform CCA")
                                        }

                                    }
                                    else if(mItem.SAPStatus__c == 'Queue CCA')
                                    {
                                        component.set('v.DynamicText', 'Already Submit Queue to Inform CCA');
                                        component.set("v.AllowSend", false);
                                    }
                                   
                                    else if(mItem.SAPStatus__c == 'Pending CCA')
                                    {
                                        component.set('v.DynamicText', 'This item has been inform SAP To mapping CCA');
                                        component.set("v.AllowSend", false);
                                    }
                                    else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                    {
                                        component.set('v.DynamicText', 'Sending Sales view to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                }
                                else
                                {
                                    if(mItem.SAPStatus__c == 'SAP Confirmed Sales/Purchasing View' && mItem.LatestIntegrationName__c == 'Initial Customer Additional Information' && 
                                      mItem.IntegrationStatus__c == 'Fail')
                                    {
                                        component.set('v.DynamicText', 'Do you need to submit Additional info again?');
                                        component.set("v.AllowSend", true);
                                    }
                                    else
                                    {
                                        component.set("v.AllowSend", false);
                                    	component.set('v.DynamicText', 'Request has been sync to SAP');
                                    }
                                    

                                }

                            }
                            //if(component.get("v.mainComponentName") == 'Supplier')
                            if(result.mRecordTypeName.includes('Supplier'))
                            {
                                if(!mItem.SAPNumber__c)
                                {
                                    if(mItem.SAPStatus__c == 'SAP Confirmed General View' || (mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.Customer__r.SupplierNumber__c))
                                    {
                                        component.set('v.DynamicText', 'General View has been sent. Do you want to Submit Purchasing data?');
                                        component.set("v.AllowSend", true);
                                    }
                                    else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                    {
                                        component.set('v.DynamicText', 'Sending Purchasing view to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                }
                                else
                                {
                                    component.set("v.AllowSend", false);
                                    component.set('v.DynamicText', 'Request has been sync to SAP');

                                }
                            }
                            component.set("v.isGeneralSent", true);
                        }
                    }

                    if(result.mRecordTypeName.includes('ShipTo'))
                    {
                        if(result.mRecordTypeName == 'ShipToCreate' )
                        {
                            
                            if(!mItem.SAPNumber__c)
                            {
                                if(!mItem.SAPStatus__c || mItem.SAPStatus__c == 'SAP Confirmed General View' || 
                                mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP')
                                {
                                    component.set('v.mDataReady', true);
                                    component.set("v.AllowSend", true);
                                    component.set('v.DynamicText', 'Do you need to confirm to Create ShipTo to SAP?');

                                    component.set("v.isGeneralSent", true);
                                }
                                if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                {
                                    component.set('v.DynamicText', 'Sending Create Ship to to SAP...');
                                    component.set("v.AllowSend", false);
                                }
                            }
                            else
                            {
                                    component.set("v.AllowSend", false);
                                    component.set('v.DynamicText', 'Request has been sync to SAP');
                           	}
                            
                        }
                        else if(result.mRecordTypeName.includes('ShipToEdit'))
                        {
                                if(!mItem.SAPNumber__c)
                                {
                                    if(!result.mAccountNumber)
                                    {
                                        component.set("v.AllowSend", false);
                                        component.set('v.DynamicText', 'This request has\'t create Customer in SAP yet.');
                                    }
                                    else if(!mItem.SAPStatus__c || mItem.SAPStatus__c == 'SAP Confirmed General View' || mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP')
                                    {
                                        component.set('v.mDataReady', true);
										component.set('v.DynamicText', 'Do you need to confirm to Edit ShipTo to SAP?');

                                        component.set("v.AllowSend", true);
                                    }
                                    else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                    {
                                        component.set('v.DynamicText', 'Sending Create Edit to to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                }
                                else
                                {
                                    component.set("v.AllowSend", false);
                                    component.set('v.DynamicText', 'Request has been sync to SAP');

                                }
                            
                            component.set("v.isGeneralSent", true);
                        }
                    }

                    else if(result.mRecordTypeName.includes('Edit'))
                    {
                        if((result.mRecordTypeName.includes('Customer') && !result.mAccountNumber) || 
                        (result.mRecordTypeName.includes('Supplier') && !result.mSupplierNumber))
                        {
                            console.log('!result.mAccountNumber')
                            if(result.mRecordTypeName.includes('Customer') && !result.mAccountNumber)
                            {
                                component.set("v.AllowSend", false);
                                component.set('v.DynamicText', 'This request has\'t create Customer in SAP yet.');
                            }
                            if(result.mRecordTypeName.includes('Supplier') && !result.mSupplierNumber)
                            {
                                component.set("v.AllowSend", false);
                                component.set('v.DynamicText', 'This request has\'t create Supplier in SAP yet.');
                            }
                        }
                        else
                        {
                            if(mItem.InternalEditField__c || mHeader.InternalEditField__c)
                            {
                                if(result.mRecordTypeName.includes('Customer'))
                                {
                                
                                    console.log('result.mAccountNumber')
                                    if(!mItem.SAPNumber__c)
                                    {
                                        console.log('result.1'+mItem.SAPStatus__c );
                                        if(mItem.SAPStatus__c === 'SAP Confirmed General View' || !mItem.SAPStatus__c ||( mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.Customer__r.AccountNumber__c))
                                        {
                                            component.set('v.DynamicText', 'Do you want to Submit Edit Customer data?');
                                            component.set("v.AllowSend", true);
                                        }
                                        else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                        {
                                            component.set('v.DynamicText', 'Sending Edit Customer view to SAP...');
                                            component.set("v.AllowSend", false);
                                        }
                                    }
                                    else
                                    {
                                        if(mItem.SAPStatus__c == 'SAP Confirmed Sales/Purchasing View' && mItem.LatestIntegrationName__c == 'Initial Customer Additional Information' && 
                                      	mItem.IntegrationStatus__c == 'Fail')
                                    	{
                                        	component.set('v.DynamicText', 'Do you need to submit Additional info again?');
                                        	component.set("v.AllowSend", true);
                                    	}
                                        else
                                        {
											component.set("v.AllowSend", false);
                                        	component.set('v.DynamicText', 'Request Edit has been sync to SAP');
                                        }

                                        console.log('result.2')
                                    }
                                }
                                if(result.mRecordTypeName.includes('Supplier'))
                                {
                                    if(!mItem.SAPNumber__c)
                                    {
                                        if(mItem.SAPStatus__c == 'SAP Confirmed General View' || !mItem.SAPStatus__c || (mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.Customer__r.SupplierNumber__c))
                                        {
                                            component.set('v.DynamicText', 'Do you want to Submit Edit Purchasing data?');
                                            component.set("v.AllowSend", true);
                                        }
                                        else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                        {
                                            component.set('v.DynamicText', 'Sending Edit Purchasing view to SAP...');
                                            component.set("v.AllowSend", false);
                                        }
                                    }
                                    else
                                    {
                                            component.set("v.AllowSend", false);
                                        	component.set('v.DynamicText', 'Request Edit has been sync to SAP');
                                    }
                                }
                            
                                component.set('v.mDataReady', true);
                                component.set("v.isGeneralSent", true);
                            }
                            else if(!mItem.InternalEditField__c && !mHeader.InternalEditField__c)
                            {
                                component.set('v.DynamicText', 'No Edit Field on records.');
                                component.set("v.AllowSend", false);
                            }
                        }
                    }
                    else if(result.mRecordTypeName.includes('Block'))
                    {
                        if((result.mRecordTypeName.includes('Customer') && !result.mAccountNumber) || 
                        (result.mRecordTypeName.includes('Supplier') && !result.mSupplierNumber))
                        {
                            if(result.mRecordTypeName.includes('Customer') && !result.mAccountNumber)
                            {
                                component.set("v.AllowSend", false);
                                component.set('v.DynamicText', 'This request has\'t create Customer in SAP yet.');
                            }
                            if(result.mRecordTypeName.includes('Supplier') && !result.mSupplierNumber)
                            {
                                component.set("v.AllowSend", false);
                                component.set('v.DynamicText', 'This request has\'t create Supplier in SAP yet.');
                            }
                        }
                        else
                        {
                            if(result.mRecordTypeName.includes('Customer'))
                            {
                                if(!mItem.SAPNumber__c)
                                {
                                    if(mItem.SAPStatus__c == 'SAP Confirmed General View' || (mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.Customer__r.AccountNumber__c))
                                    {
                                        component.set('v.DynamicText', 'Do you want to Submit Block Customer data?');
                                        component.set("v.AllowSend", true);
                                    }
                                    else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                    {
                                        component.set('v.DynamicText', 'Sending Block Customer view to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                }
                                else
                                {
                                    component.set("v.AllowSend", false);
                                    component.set('v.DynamicText', 'Request Block has been sync to SAP');

                                }
                            }
                            if(result.mRecordTypeName.includes('Supplier'))
                            {
                                if(!mItem.SAPNumber__c)
                                {
                                    if(mItem.SAPStatus__c == 'SAP Confirmed General View' || (mItem.SAPStatus__c == 'Unsuccessful Send Sales/Purchasing view to SAP' && mItem.Customer__r.SupplierNumber__c))
                                    {
                                        component.set('v.DynamicText', 'Do you want to Submit Block Purchasing data?');
                                        component.set("v.AllowSend", true);
                                    }
                                    else if(mItem.SAPStatus__c == 'Send Sales/Purchasing View To SAP')
                                    {
                                        component.set('v.DynamicText', 'Sending Block Purchasing view to SAP...');
                                        component.set("v.AllowSend", false);
                                    }
                                }
                                else
                                {
                                    component.set("v.AllowSend", false);
                                    component.set('v.DynamicText', 'Request Block has been sync to SAP');

                                }
                            }
                            component.set('v.mDataReady', true);
                            component.set("v.isGeneralSent", true);
                        }
                    }
                    else if(result.mRecordTypeName.includes('Change'))
                    {
                        
                    }

                    //var validatemessage = 'ByPass';
                    /*if(!mHeader.Customer__r.SAPConfirmedData__c)
                    {
                        component.set("v.isFirstTime", true);
                        var validatemessage = helper.validateRequiredFieldHelper(mHeader, mItem, component.get("v.mainComponentName"));

                        if(validatemessage[0] == 'ByPass')// && mToken != 'blank')
                        {
                            component.set('v.mDataReady', true);
                            console.log('ready');

                        }
                        else
                        {
                            component.set('v.mValidateMessageList', validatemessage);
                            console.log('data blank');

                        }
                    }
                    else
                    {
                        component.set("v.isFirstTime", false);

                    }*/
                    //helper.toastEvent('Success','Update Service Cost to SAP','success');
                }
                else
                {
                    helper.toastEvent('Error','Internal Error Please contact your administrator.','error');
                }
                component.set('v.loaded', true);
                console.log('SUCCESS');
            }
            else
            {
                helper.toastEvent('Error','Internal Error Please contact your administrator.','error');
                console.log('ERROR:: ',data.message);
                helper.closeModal(component);
                component.set('v.loaded', true);

            }
        });
        $A.enqueueAction(action);

    },
    
    submit : function(component, event, helper) 
    {
        var mButtonName = component.get("v.ConfirmButtonName");
        if(mButtonName == 'Confirm')
        {
            var TypeToSend = component.get("v.mainComponentName");
            helper.SendToSAP(component);
        }
        else if (mButtonName == 'Inform CCA')
        {
            helper.SendToSAP(component);
            //helper.toastEvent('Success','MOCK successfully!','success');
            //helper.closeModal(component);
        }


    },

    closeModal : function(component, event, helper) 
    {
        helper.closeModal(component);
    } 
})