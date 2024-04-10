({
    doInit : function(component, event, helper) {
        helper.getUser(component, event, helper);
    },
    reInit : function(component, event, helper) {
    },
    top : function(component, event, helper) {
        var scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }
})