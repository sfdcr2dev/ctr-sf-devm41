({
    doInit : function(component, event, helper) {
        //helper.getProfile(component);
        helper.getDefaultData(component);

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
        var validatedList = [];
        var validateMissingField = 'Please fill in: ';
        component.set('v.validateFieldShow',false);
        component.set('v.validateMissingField','');
        var validatemessagev2 = helper.checkRequiredFieldsv2(component);
        if(validatemessagev2.length > 0)
        {
            console.log(JSON.stringify(validatemessagev2));
            // helper.toastEvent('Error',validateMissingField+validatemessage.toString(),'error');
            component.set('v.validateFieldShow',true);
            component.set('v.validateMissingFieldList',validatemessagev2);
        }
        else
        {
                component.set('v.validateFieldShow',false);
                helper.saveRequestItemAndRequestHeader(component);
        } 

        // var validatemessage = helper.checkRequiredFields(component);
        // console.log('validatemessage:'+ validatemessage);
        // if(validatemessage.length > 0)
        // {
        //     // helper.toastEvent('Error',validateMissingField+validatemessage.toString(),'error');
        //     component.set('v.validateFieldShow',true);
        //     component.set('v.validateMissingField',validateMissingField+validatemessage.toString());
        // }
        // else{
        //     component.set('v.validateFieldShow',false);
        //     helper.saveRequestItemAndRequestHeader(component);
        // } 

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
        helper.addFieldChangeToJson(component,event, 'Header');
    },
    handleAddJsonItemr: function(component, event, helper) 
    {
        helper.addFieldChangeToJson(component,event, 'Item');
    }



})