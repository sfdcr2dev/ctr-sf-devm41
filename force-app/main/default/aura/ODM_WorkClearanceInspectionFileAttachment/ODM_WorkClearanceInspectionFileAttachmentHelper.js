({
    retrieveRelated: function (component) {
        let action = component.get('c.getRelatedObjects');
        action.setParams({
            recordIdentifier: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let returnValue = response.getReturnValue();
                try {
                    component.set('v.filesRelated', returnValue.files);
                } catch (error) {
                    console.log(JSON.parse(JSON.stringify(returnValue)));
                    console.error(error);
                }
            } else if (state === 'ERROR') {
                let errors = response.getError();

                console.error(JSON.parse(JSON.stringify(errors)));
            }
            component.set('v.isLoading', false);
            if (!component.get('v.finishedLoading')) {
                component.set('v.finishedLoading', true);
            }
        });

        component.set('v.isLoading', true);
        $A.enqueueAction(action);
    },
});