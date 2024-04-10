({
	doInit : function(component, event, helper) {
        component.set('v.isLoaded', true);
    },

	toggleSection: function (component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute('data-auraid');
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section'); // slds-is-close 
        }
    },
    handleLoad : function(component, event, helper){
        $A.util.addClass(component.find("spinner"), "slds-hide");    
    },
})