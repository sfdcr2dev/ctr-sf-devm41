({
    close : function(component, event, helper) {
        var closeEvent = component.getEvent('eqccCreationEvent');
        closeEvent.fire();
    }
})