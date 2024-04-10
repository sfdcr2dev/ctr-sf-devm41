({
    init: function (component, event, helper) {
//        var recordId = component.get("v.recordId");
//        var check = component.get('c.checkNotiOrder');
//
//        check.setParams({
//            "recordId": recordId
//        });
//
//        check.setCallback(this, function (response) {
//            if (response.getState() === 'SUCCESS') {
//                var link = response.getReturnValue();
//                //alert(link);
//                //alert('jsonnnn1-',response.getReturnValue());
//                if (response.getReturnValue()) {
//                    var urlEvent = $A.get("e.force:navigateToURL");
//
//                    urlEvent.setParams({
//                        "url": link
//                    });
//
//                    urlEvent.fire();
//                }
//
//            } else if (response.getState() === 'ERROR') {
//                reject(response.getError());
//            }
//        });
//        $A.enqueueAction(check);

        var action = component.get("c.redirectToRecordDisplay");
        action.setCallback(this, function (response) {
            if (response.getState() === 'SUCCESS') {
                const result = response.getReturnValue();
                if (result.Work_Clearance_Record_Display__c) {
                    var urlEvent = $A.get("e.force:navigateToURL");
                    var recordId = component.get('v.recordId');

                    urlEvent.setParams({
                        "url": `/lightning/cmp/c__${result.Work_Clearance_Record_Display__c}?c__recordId=${recordId}`
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