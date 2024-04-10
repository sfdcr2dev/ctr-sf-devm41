({
    doInit: function (component, event, helper) {
        helper.getRelatedObjects(component);
        helper.checkWriteAccess(component);
    },

    forceRefresh: function(component, event, helper){
        $A.get('e.force:refreshView').fire();
    },

     insertNewItem: function (component, event, helper) {
         let pageRef;
         let navLink = component.find("navLink");
         let recordId = component.get("v.recordId");
   
         pageRef = {
             type: "standard__component",
             attributes: {
                 "componentName": "c__THOR_InsertItemObjectPart"
             },
             state: {
                 "c__notificationId": recordId
             },
         };
         navLink.navigate(pageRef, true);
     },

     navigateToNotificationDetail : function(component, event, helper){
        var pageRef = component.get("v.pageReference");
        let navLink = component.find("navLink");
        pageRef = {
            type: "standard__component",
            attributes: {
                "componentName": "c__THOR_NotificationRecordDisplay"
            },
            state: {
                "c__recordId": component.get("v.recordId")
            },
        };
        navLink.navigate(pageRef, true);
     }
})