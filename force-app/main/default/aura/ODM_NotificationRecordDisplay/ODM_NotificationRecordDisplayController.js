({
    doInit: function (component, event, helper) {
        let pageref = component.get('v.pageReference');
        if (pageref && !component.get('v.recordId')) {
            let { c__recordId } = pageref.state;
            component.set('v.recordId', c__recordId);
        }

        component.find('recordData').reloadRecord(true);
    },
    handleRecordUpdated: function (component, event, helper) {
        const eventParams = event.getParams();

        let { changeType, changedFields } = eventParams;
        if (changeType = 'LOADED') {
            helper.handleSetInterval(component);
            helper.handleSetTimeout(component);
            helper.hasWriteAccess(component);
        } else if (changeType === 'CHANGED' && changedFields && changedFields['Integration_Status__c']) {
            component.set(`v.notificationRecord.Integration_Status__c`, changedFields['Integration_Status__c'].value);

            helper.handleSetInterval(component);
            helper.handleSetTimeout(component);
            helper.hasWriteAccess(component);
        }
        component.set('v.isAlertIntegration',
            !component.get('v.notificationRecord.Integration_Status__c')
            || component.get('v.notificationRecord.Integration_Status__c') === 'Failed'
        );

        helper.truncHistoryDetail(component);
        component.set('v.isLoadingRecord', false);
    },
    doneRendering: function (component, event, helper) {

    },
    reInit: function (component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },
    handleSelectButtonMenu: function (component, event, helper) {
        var selectedFunc = event.getParam('value');
        if (selectedFunc) {
            $A.enqueueAction(component.get(selectedFunc));
        }
    },
    handleTabSelected: function (component, event, helper) {
        component.set('v.activeTabName', event.getSource().get('v.value'));
    },
    showEditModal: function (component, event, helper) {
        try {
            component.find('navService').navigate(
                {
                    type: 'standard__webPage',
                    attributes: {
                        url: `/one/one.app#${window.btoa(
                            JSON.stringify({
                                componentDef: `c:ODM_NotificationEditPage`,
                                attributes: {
                                    recordId: component.get('v.recordId'),

                                    uuid: 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
                                        let r = (Math.random() * 16) | 0,
                                            v = c == 'x' ? r : (r & 0x3) | 0x8;
                                        return v.toString(16);
                                    })
                                }
                            })
                        )}`
                    }
                },
                false
            );
        } catch (err) {
            alert(err.message || err);
        }
    },
    toggleCloseModal: function (component, event, helper) {
        component.set('v.isModalAction.close', !component.get('v.isModalAction.close'))
    },
    toggleDiscardModal: function (component, event, helper) {
        component.set('v.isModalAction.discard', !component.get('v.isModalAction.discard'))
    },
    closeNotification: function (component, event, helper) {
        $A.enqueueAction(component.get('c.toggleCloseModal'));

        let faultCode = component.get('v.notificationRecord.Fault_Code__c');
        let notificationStatus = component.get('v.notificationRecord.Notification_Status__c');

        if (notificationStatus != 'Closed') {
            helper.setNotificationStatusClosed(component, event);
        } else {
            var toastEvent = $A.get('e.force:showToast');
            toastEvent.setParams({
                type: 'Error',
                title: 'Error!',
                message: 'Notification already closed.'
            });
            toastEvent.fire();
        }
    },
    discardNotification: function (component, event, helper) {
        try {
            component.find('recordData').deleteRecord(
                $A.getCallback(() => {
                    event.preventDefault();
                    component.set('v.recordId', '');
                    var navService = component.find('navService');
                    navService.navigate(
                        {
                            type: 'standard__navItemPage',
                            attributes: {
                                apiName: 'ODM_Notifications'
                            }
                        },
                        true
                    );
                })
            );
        } catch (e) {
            console.error(e);
        }
    },
    resendNotification: function (component, event, helper) {
        component.find('recordResendForm').submit();
        $A.get('e.force:refreshView').fire();
    },
    closeAlertIntegration: function (component, event, helper) {
        component.set('v.isAlertIntegration', false);
    },
    handleLoadRecordEdit: function (component, event, helper) {
        let recordUi = event.getParam('recordUi');
        component.set('v.notificationRecordUi', JSON.parse(JSON.stringify(recordUi)));
        helper.getPISUsers(component, event, helper);
        helper.getFunctionalLocations(component, event, helper);
        component.set('v.isLoadingRecordUi', false);
    },
})