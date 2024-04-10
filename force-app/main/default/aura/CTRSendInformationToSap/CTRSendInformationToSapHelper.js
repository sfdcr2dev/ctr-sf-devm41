({
    validateRequiredFieldHelper: function (mHeader, mItem, mTypeValidate)
    {
        console.log('validate helper');
        var validateMissingField = 'Missing Required Field: '; 
        var ValidateMessageList = [];
        /*if(mHeader === undefined)
        {
            ValidateMessageList.push('Missing Header Record');
        }
        else
        {
            console.log('validate header:'+mHeader.Country__c);
            if(mTypeValidate == 'Customer')
            {
                //Check Required field.
                //Import data
                if(!mHeader.SalesOrganization__c) {ValidateMessageList.push(validateMissingField+'SalesOrganization__c');}
                if(!mHeader.DistributionChannel__c){ValidateMessageList.push(validateMissingField+'DistributionChannel__c');}
                if(!mHeader.Division__c){ValidateMessageList.push(validateMissingField+'Division__c');}

                //Table Central Data (GENERAL_DATA)
                if(!mHeader.AccountGroup__c){ValidateMessageList.push(validateMissingField+'AccountGroup__c');}
                if(mHeader.Country__c === undefined){ValidateMessageList.push(validateMissingField+'Country__c');}

                //Table Address (ADDR_GENERAL_DATA)
                if(!mHeader.CustomerNameLocal1__c){ValidateMessageList.push(validateMissingField+'CustomerNameLocal1__c');}
                if(!mHeader.CustomerNameEN1__c){ValidateMessageList.push(validateMissingField+'CustomerNameEN1__c');}

                if(mHeader.CityStateLocal__c === undefined){ValidateMessageList.push(validateMissingField+'CityStateLocal__c');}
                if(!mHeader.CityStateLocalText__c){ValidateMessageList.push(validateMissingField+'CityStateLocalText__c');}
                if(mHeader.CityStateEN__c === undefined){ValidateMessageList.push(validateMissingField+'CityStateEN__c');}
                if(!mHeader.CityStateENText__c){ValidateMessageList.push(validateMissingField+'CityStateENText__c');}
                if(!mHeader.StreetLocal__c){ValidateMessageList.push(validateMissingField+'StreetLocal__c');}
                if(!mHeader.StreetEN__c){ValidateMessageList.push(validateMissingField+'StreetEN__c');}
                if(!mHeader.CustomerSearchTermLocal__c){ValidateMessageList.push(validateMissingField+'CustomerSearchTermLocal__c');}
                if(!mHeader.CustomerSearchTermEN__c){ValidateMessageList.push(validateMissingField+'CustomerSearchTermEN__c');}

                //Table Sales Data(SALES_VIEW)
                if(!mHeader.Incoterms__c){ValidateMessageList.push(validateMissingField+'Incoterms__c');}
                //if(!mHeader.Incoterms2__c){ValidateMessageList.push(validateMissingField+'Incoterms2__c');} //Field doesn't created yet
                if(!mHeader.Currency__c){ValidateMessageList.push(validateMissingField+'Currency__c');}
                if(mHeader.TermofPayment__c=== undefined){ValidateMessageList.push(validateMissingField+'TermofPayment__c');}
                //if(!mHeader.CustomerPayment__c){ValidateMessageList.push(validateMissingField+'CustomerPayment__c');} //Field doesn't created yet
                if(!mHeader.TAXClassification__c){ValidateMessageList.push(validateMissingField+'TAXClassification__c');}
            }
            else if(mTypeValidate == 'Supplier')
            {
                //Table Central Data (GENERAL_DATA)
                if(!mHeader.AccountGroup__c){ValidateMessageList.push(validateMissingField+'AccountGroup__c');}

                //Table Address																
                if(!mHeader.CustomerNameLocal1__c){ValidateMessageList.push(validateMissingField+'CustomerNameLocal1__c');}
                if(!mHeader.CustomerNameEN1__c){ValidateMessageList.push(validateMissingField+'CustomerNameEN1__c');}
                if(mHeader.CityStateLocal__c === undefined){ValidateMessageList.push(validateMissingField+'CityStateLocal__c');}
                if(!mHeader.CityStateLocalText__c){ValidateMessageList.push(validateMissingField+'CityStateLocalText__c');}
                if(mHeader.CityStateEN__c === undefined){ValidateMessageList.push(validateMissingField+'CityStateEN__c');}
                if(!mHeader.CityStateENText__c){ValidateMessageList.push(validateMissingField+'CityStateENText__c');}
                if(mHeader.Country__c === undefined){ValidateMessageList.push(validateMissingField+'Country__c');}
                if(!mHeader.Language__c){ValidateMessageList.push(validateMissingField+'Language__c');}
                if(!mHeader.Currency__c){ValidateMessageList.push(validateMissingField+'Currency__c');}
                if(!mHeader.TermofPayment__c){ValidateMessageList.push(validateMissingField+'TermofPayment__c');}
                if(!mHeader.CompanyCode__c){ValidateMessageList.push(validateMissingField+'CompanyCode__c');}
                if(!mHeader.ReconciliationAccount__c){ValidateMessageList.push(validateMissingField+'ReconciliationAccount__c');}
                if(!mHeader.CashManagementGroup__c){ValidateMessageList.push(validateMissingField+'CashManagementGroup__c');}
            }
            
        }
        if(mItem.Status__c != 'New'){ValidateMessageList.push('Status: Allow Only Send to SAP only New Status ');}*/
        if(ValidateMessageList.length == 0){ValidateMessageList.push('ByPass');}
        return ValidateMessageList;
    },

    SendToSAP : function(component, event, helper) 
    {
        component.set('v.loaded', false);
        var action = component.get("c.CTRCommitteeSendInformationToSap");
        
        action.setParams({
            mRequestHeader: component.get('v.mRequestHeader'),
            mRequestItem: component.get('v.mRequestItem'),
            //mToken: component.get('v.mToken'),
            mSapType: component.get("v.mainComponentName")
        });
        action.setCallback(this, function (response) 
        {
            if (response.getState() === 'SUCCESS') 
            {
                var result = response.getReturnValue();
                console.log('Send to SAP Result: '+result);
                if(result.includes('Success'))
                {
                    this.toastEvent('Success','Send successfully!','success');
                }
                else
                {
                    this.toastEvent('Error','Send unsuccessfully.','error');
                }
                console.log('SUCCESS');
            }
            else if(response.getState() === 'ERROR')
            {
                console.log('ERROR: ',response.message);
                this.toastEvent('Error','Internal Error Please contact your administrator.','error');
            }
            else
            {
                console.log('ERROR:: ',response.message);
                this.toastEvent('Error','Internal Error Please contact your administrator.','error');
            }
            component.set('v.loaded', true);
            this.closeModal(component);
        });
        $A.enqueueAction(action);
    },

    toastEvent : function(Title, Message, Type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": Title,
            "message": Message,
            "type": Type
        });
        toastEvent.fire();
    },

    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },
})