({
    parseObject: function (obj) {
        return JSON.parse(JSON.stringify(obj));
    },
    closeModal: function () {
        $A.get("e.force:closeQuickAction").fire();
    },
    displayToast: function (type, message) {
        var duration = type.toLowerCase() == 'error' ? 8000 : 5000;
        var toastEvent = $A.get('e.force:showToast');
        toastEvent.setParams({
            key: type,
            type: type,
            message: message,
            duration: duration
        });
        toastEvent.fire();
    },
    startSpinner: function (component) {
        component.set('v.isLoading', true);
    },
    stopSpinner: function (component) {
        component.set('v.isLoading', false);
    },
    calloutUpdateDataAsset: function (component, event, helper) {
        return new Promise((resolve, reject) => {
            var action = component.get('c.calloutUpdateDataAsset')
            action.setParams({
                recordId: component.get('v.recordId')
            });
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    var result = response.getReturnValue();
                    var isSuccess = result === 'Success'
                    if (!isSuccess) {
                        component.find('messages').setError(result)
                        // helper.displayToast('error', result)
                    }
                    resolve(isSuccess)
                }
                else if (state === 'ERROR') {
                    resolve(false)
                    var errors = response.getError();
                    errors.forEach(error => console.error(error));
                }
            });
            component.find('messages').setError()
            $A.enqueueAction(action);
        })
    },
})