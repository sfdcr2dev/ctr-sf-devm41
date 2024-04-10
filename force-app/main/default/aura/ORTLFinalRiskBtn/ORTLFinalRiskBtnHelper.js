({
    // Create and display custom modal.
    showModal: function (component, event, helper) {
        $A.createComponent("c:ORTLFinalRisk", {
            recordId: component.get('v.recordId')
        },
            function (content, status) {
                if (status === "SUCCESS") {
                    component.find('overlayLib').showCustomModal({
                        header: "Final Risk Assessment",
                        body: content,
                        showCloseButton: true,
                        cssClass: "",
                    })
                    helper.closeQuickAction(component, event, helper)
                }
            });
    },
    // Utility method for closing quick action.
    closeQuickAction: function (component, event, helper) {
        let dismissActionPanel = $A.get("e.force:closeQuickAction")
        if (dismissActionPanel) {
            dismissActionPanel.fire()
        }
    },
})