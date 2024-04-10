({
    init : function(component, event, helper) {},

    navigateHelper: function (component, event) {
        let recordId = event.getParam("theRecordId");
        let toComponent = event.getParam("toThisComponent");
        let navLink = component.find("navLink");
        let pageRef = {
            type: "standard__component",
            attributes: {
                componentName: toComponent,
            },
            state: {
                c__recordId: recordId,
            }
        };
        navLink.navigate(pageRef, true);
        console.log('navigation');
    },
})