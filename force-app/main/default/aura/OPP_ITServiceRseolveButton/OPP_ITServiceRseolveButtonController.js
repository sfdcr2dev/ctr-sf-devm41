({
    onInit: function (component, event, helper) {

    },
    onClose: function (component, event, helper) {
        helper.closeModal()
    },
    handleLoad: function (component, event, helper) {
        var recordUi = event.getParam('recordUi')
        component.set('v.recordUi', recordUi)
        var recordTypeName = component.get('v.recordUi.record.recordTypeInfo.name')
        component.set('v.recordTypeName', recordTypeName)

        var action = component.get('c.getCaseLineItemByCaseId')
        action.setParams({
            'recordId': component.get('v.recordId'),
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === 'SUCCESS') {
                var result = response.getReturnValue();
                component.set("v.isDisable", result.some(item => !item.New_WinNo__c));
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                errors.forEach(error => console.error(error));
            }
            helper.stopSpinner(component)
        });
        if (recordTypeName.includes('Hardware')) {
            helper.startSpinner(component)
            $A.enqueueAction(action);
        } else {
            component.set('v.isDisable', false);
        }
    },
    handleSubmit: function (component, event, helper) {
        event.preventDefault();
        helper.startSpinner(component)
        if (component.get('v.isDisable')) {
            helper.stopSpinner(component)
        }

        if (component.get('v.recordTypeName').includes('Hardware')) {
            helper.calloutUpdateDataAsset(component, event, helper)
                .then((isSuccess) => {
                    if (isSuccess) {
                        component.find('recordEditForm').submit()
                    }
                    helper.stopSpinner(component)
                }, () => { })
        }
        else {
            component.find('recordEditForm').submit()
        }
    },
    handleSuccess: function (component, event, helper) {
        helper.stopSpinner(component)
        helper.closeModal()

    },
    handleError: function (component, event, helper) {
        helper.stopSpinner(component)

    },
})