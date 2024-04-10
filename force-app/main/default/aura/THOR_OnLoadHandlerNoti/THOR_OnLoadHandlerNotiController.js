({
    init: function (component, event, helper) {
//        var action = component.get("c.isRedirected");
//        action.setCallback(this, function (response) {
//            if (response.getState() === 'SUCCESS') {
//                if (response.getReturnValue()) {
//                    var urlEvent = $A.get("e.force:navigateToURL");
//                    var recordId = component.get('v.recordId');
//
//                    urlEvent.setParams({
//                        "url": "/lightning/cmp/c__THOR_NotificationRecordDisplay?c__recordId=" + recordId
//                    });
//                    urlEvent.fire();
//                }
//
//            } else if (response.getState() === 'ERROR') {
//                reject(response.getError());
//            }
//        });
//        $A.enqueueAction(action);

        var action = component.get("c.redirectToRecordDisplay");
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                const result = response.getReturnValue();
                if (result.Notification_Record_Display__c) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var recordId = component.get('v.recordId');

                    urlEvent.setParams({
                        "url": `/lightning/cmp/c__${result.Notification_Record_Display__c}?c__recordId=${recordId}`
                    });
                    urlEvent.fire();
                }

            } else if (response.getState() === 'ERROR') {
                reject(response.getError());
            }
        });
        $A.enqueueAction(action);
    }
})