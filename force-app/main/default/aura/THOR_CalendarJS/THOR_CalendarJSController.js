({
    // set the isMobile attribute
    init : function(component, event, helper){
        helper.getIsMobile(component);
    },

    scriptsLoaded : function(component, event, helper) {
        helper.getResponse(component);
    },
})