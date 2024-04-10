({
    doInit : function(component, event, helper) {
        helper.retireveRelated(component, event);
    },

    preview : function(component, event, helper) {

        var index = event.currentTarget.id;

        $A.get('e.lightning:openFiles').fire({
           recordIds: [index]
        });
    },
    openPDF : function(component, event, helper){
        var recordId = component.get("v.wcId");
        var url = '/apex/WorkclearancePdf?id=' + recordId;
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": url
        });
        urlEvent.fire();
    }

})