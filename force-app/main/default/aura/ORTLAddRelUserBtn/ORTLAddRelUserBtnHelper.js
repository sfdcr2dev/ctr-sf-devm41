({
    /** 
     * this function used to call another component to show custom modal
     * by way content is component that you call 
     */
    showModal: function (component, event, helper) {
        $A.createComponent("c:ORTLAddRelUser", {
            recordId: component.get('v.recordId')
        },
            function (content, status) {
                if (status === "SUCCESS") {
                    component.find('overlayLib').showCustomModal({
                        header: "Add CC to",
                        body: content,
                        showCloseButton: true,
                        cssClass: "",
                    })
                    helper.closeQuickAction(component, event, helper)
                }
            });
    },
    closeQuickAction: function (component, event, helper) {
        let dismissActionPanel = $A.get("e.force:closeQuickAction")
        if (dismissActionPanel) {
            dismissActionPanel.fire()
        }
    },
})