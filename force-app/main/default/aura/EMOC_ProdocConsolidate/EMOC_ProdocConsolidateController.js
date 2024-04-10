({
	doInit : function(component, event, helper) {
		helper.getOptions(component);
	},
    onCancelClick : function(component, event, helper) {
        $A.get('e.force:closeQuickAction').fire();
    },
    onConsolidateClick : function(component, event, helper) {
        console.log('[onConsolidateClick] -----');
        helper.validateData(component);
        if(component.get('v.allowToConsolidate')) {
            helper.prepareToConsolidate(component);
        }
    },
    onDocTypeClick : function(component, event, helper) {
        var name = event.getSource().get('v.name');
        console.log('[onDocTypeClick] name -----' + name);
        var options = component.get('v.options');
        options.forEach(each => {
            if(each.value === name) {
            	each.isSelected = true;
        	} else each.isSelected = false;
        });
        component.set('v.selectedOption', name);
        component.set('v.options', options);
        component.set('v.selectedRows', null);
        helper.retrieveData(component);
        helper.validateData(component);
    },
    onRowSelected : function(component, event, helper) {
        console.log('[onRowSelected] -----');
        component.set('v.selectedRows', event.getParam('selectedRows'));
        helper.validateData(component);
    },
})