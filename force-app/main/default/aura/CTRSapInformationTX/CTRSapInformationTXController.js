({
    doInit : function(component, event, helper) {
        //helper.getIdFormHeader(component);
        //helper.getRecordTypeName(component);
        //helper.getDefaultData(component);

    },
    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");    


    },
    handleCancel: function (component, event, helper) {
        component.set('v.isModalOpen',false);
        $A.get("e.force:closeQuickAction").fire();
    },
    handleSave: function (component, event, helper) {
        event.preventDefault();

        //Check validate fields 
        var validateMissingField = 'Please fill in: ';
        var validatemessage = helper.checkRequiredFields(component);
        console.log('Check required fields ',validatemessage);
        if(validatemessage.length > 0){
            // helper.toastEvent('Error',validateMissingField+validatemessage.toString(),'error');
            component.set('v.validateFieldShow',true);
            component.set('v.validateMissingField',validateMissingField+validatemessage.toString());
        }
        else{
            component.set('v.validateFieldShow',false);
            helper.saveRequestItemAndRequestHeader(component);
        } 

    },
    handleCheckboxChange: function(component, event, helper) {
        // Get the checkbox value
        var isChecked = event.getSource().get("v.checked");
        var isCmp = event.getSource().get("v.id");
        // Set the value in the requestFormObj
        component.set(isCmp, isChecked);
        
    },
    handleToggleSection : function(component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute("data-auraid");

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section'); // slds-is-close 
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
                var fieldChangedList = component.get('v.ChangedFieldForEDITHeader');

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
                    component.set('v.ChangedFieldForEDITHeader', fieldChangedList);
            }
        }

    }
    
})