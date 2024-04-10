({
    doInit : function(component, event, helper) {
        helper.getReqItemInfo(component);
        helper.getUserName(component);
        helper.validateUserProfile(component);
		helper.checkItem(component);

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