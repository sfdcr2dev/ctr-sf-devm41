({
    doInit: function (component, event, helper) {
        //helper.getIdFormHeader(component);
        //helper.getRequired(component);
        //helper.getRecordTypeName(component);
        //helper.getDefaultData(component);
        var mHeader = component.get('v.requestFormHeaderObj');
        var mItem = component.get('v.requestFormItemObj');
        component.set('v.AccountGroupValue', mHeader.AccountGroup__c);
        console.log( component.get('v.AllDistributionChannelList'));
        if(!component.get('v.recordTypeName').includes('Edit'))
        {
            if(mItem.BusinessUnit__c == 'TOP')
            {
                if(component.get('v.recordTypeName').includes('Customer'))
                {
                    helper.DependencyHelper(component, event, 'onLoad');
                }
                else
                {
                    component.set('v.DistributionChannelList', component.get('v.AllDistributionChannelList'));
                }
            }
            else
            {
                component.set('v.DistributionChannelList', component.get('v.AllDistributionChannelList'));
            }
        }
        else
        {
            component.set('v.DistributionChannelList', component.get('v.AllDistributionChannelList'));
        }

        if(component.get('v.SentGeneralView'))
        {
            component.set('v.DisabledDistribution',true);
        }
        


    },
    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");    
    },
    handleToggleSection: function (component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute('data-auraid');

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section'); // slds-is-close 
        }
    },
    handleAddJsonHeader: function(component, event, helper) 
    {
        if(component.get('v.recordTypeName').includes('Edit'))
        {
            helper.addFieldChangeToJson(component,event,'Header');
        }
    },
    handleAddJsonItem: function(component, event, helper) 
    {
        if(component.get('v.recordTypeName').includes('Edit'))
        {
            helper.addFieldChangeToJson(component,event,'Item');
        }
    },
    LookupChanged: function(component, event, helper) 
    {
        if(component.get('v.recordTypeName').includes('Edit'))
        {
            if(event.getParam("Api"))
            {
                var source = 'SAP Information';
                var Label = event.getParam("Label");
                var Api = event.getParam("Api");
                var Value = (event.getParam("Value"))?event.getParam("Value"):'';
                if(Value)
                {
                    Value.replace("[", "");
                    Value.replace("]", "");
                }
                console.log('Label:'+Label);
                console.log('Api:'+Api);
                console.log('Value:'+Value);
                var fieldChangedList = component.get('v.ChangedFieldForEDITItem');
    
                var isExisted = false;
                    for(var existing of fieldChangedList)
                    {
                        if(existing.Api == Api)
                        {
                            existing.Label = Label;
                            existing.Value = Value;
                            existing.User = component.get('v.currentUserName');
                            existing.Source = source;
                            
                            isExisted = true;
                        }
                    }
                    if(isExisted == false)
                    {
                        var mJson = '{"Label":"'+Label+'",'; 
                        mJson += '"Api":"'+Api+'",';
                        mJson += '"Source":"'+source+'",';
                        mJson += '"User":"'+component.get('v.currentUserName')+'",';
                        mJson += '"Value":"'+Value+'"}';
                        var mObj = JSON.parse(mJson);
                        fieldChangedList.push(mObj);
                    }
                    console.log('field change: '+JSON.stringify(fieldChangedList));
    
                    component.set('v.ChangedFieldForEDITItem', fieldChangedList);
            }
        }
    },

    onChangeAccountGroup: function(component, event, helper) 
    {
        var AccountGroup = component.get('v.AccountGroupValue');
        console.log('AccountGroup__c'+AccountGroup);
        var mHeader = component.get('v.requestFormHeaderObj');
        console.log('mHeader'+mHeader.AccountGroup__c);
        //mHeader.AccountGroup__c = AccountGroup;
        var mItem = component.get('v.requestFormItemObj');

        //component.set('v.requestFormHeaderObj',mHeader);
        if(mItem.BusinessUnit__c == 'TOP')
        {
            if(component.get('v.recordTypeName').includes('Customer'))
            {
                helper.DependencyHelper(component, event, 'onChange');
            }
        }
        if(component.get('v.recordTypeName').includes('Edit'))
        {
            helper.addFieldChangeToJson(component,event,'Item');
        }
    }
    
    /*handleSave: function (component, event, helper) {
        event.preventDefault();
        //Check validate fields 
        var validateMissingField = 'Please fill in: ';
        var validatemessage = helper.checkRequiredFields(component);
        if(validatemessage.length > 0){
            component.set('v.validateFieldShow',true);
            component.set('v.validateMissingField',validateMissingField+validatemessage.toString());
        }
        else{
            component.set('v.validateFieldShow',false);
            helper.saveRequestHeader(component);
        }

        
    },
    handleCancel: function (component, event, helper) {
        helper.closeModal(component);
    },*/
    
})