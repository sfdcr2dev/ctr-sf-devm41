({
    // If run on desktop environment close quick action and create custom modal.
    doInit: function (component, event, helper) {
        let formFactor = component.get('v.formFactor');

        if (formFactor === 'DESKTOP') {
            helper.showModal(component, event, helper)
        }
    },
})