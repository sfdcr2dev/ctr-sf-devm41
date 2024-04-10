({
    handleSetTimeout: function (component) {
        var timeout = window.setTimeout(
            $A.getCallback(() => {
                console.warn('Timeout');
                if (
                    component.get('v.notificationRecord.Integration_Status__c') === 'In Progress' &&
                    component.find('recordTimeoutForm')
                ) {
                    component.find('recordTimeoutForm').submit();
                }
            }),
            30 * 1000
        );
        component.set('v.timeout', timeout);
    },
    handleSetInterval: function (component) {
        var intervalGetInfo = window.setInterval(
            $A.getCallback(() => {
                if (
                    component.find('recordData') &&
                    component.get('v.notificationRecord.Integration_Status__c') &&
                    component.get('v.notificationRecord.Integration_Status__c') === 'In Progress'
                ) {
                    component.find('recordData').reloadRecord(true);
                } else if (
                    component.get('v.interval') &&
                    component.find('recordData') &&
                    component.get('v.notificationRecord.Integration_Status__c') !== 'In Progress'
                ) {
                    console.warn('clearInterval');
                    window.clearInterval(component.get('v.interval'));
                    component.set('v.interval', null);
                    window.clearTimeout(component.get('v.timeout'));
                    component.set('v.timeout', null);
                }
            }),
            5000
        );
        component.set('v.interval', intervalGetInfo);
    },
    truncHistoryDetail: function (component) {
        let notificationRecord = component.get('v.notificationRecord');
        if (notificationRecord) {
            let historyDetail = notificationRecord.History_Detail__c;
            let userStatus = notificationRecord.User_Status__c;
            let type = notificationRecord.Type__c;

            component.set('v.historyDetail', historyDetail);
            component.set('v.userStatus', userStatus);
            component.set('v.type', type);

            if (historyDetail) {
                historyDetail = historyDetail.replace(/\n/g, '<br />');
            }

            component.set('v.allText', historyDetail);

            if (historyDetail && historyDetail.length > 200) {
                let truncatedText = historyDetail.slice(0, 200);
                component.set('v.showViewMore', true);
                component.set('v.showViewLess', true);
                component.set('v.truncatedText', truncatedText);
            }
        }
    },
    hasWriteAccess: function (component) {
        let recordId = component.get('v.recordId');

        if (recordId) {
            let action = component.get('c.hasWriteAccess');

            action.setParams({
                notificationId: recordId
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.hasWriteAccess', response.getReturnValue());
                } else if (state === 'ERROR') {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error('Error message: ' + errors[0].message);
                        }
                    } else {
                        console.log('Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    setNotificationStatusClosed: function (component, event) {
        let action = component.get('c.setNotificationStatus');
        action.setParams({
            notificationId: component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                setTimeout(
                    $A.getCallback(() => {
                        component.find('recordData').reloadRecord(true);
                    }),
                    1000
                );
            } else if (state === 'ERROR') {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error('Error message: ' + errors[0].message);
                    }
                } else {
                    console.log('Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getPISUsers: function (component, event, helper) {
        let recordUi = component.get('v.notificationRecordUi');

        let fields = [
            'Requester_PISUser__c'
        ];

        let pisuserIds = [];
        fields.forEach(function (field) {
            let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
            id && pisuserIds.push(id);
        });

        if (pisuserIds.length > 0) {
            let action = component.get('c.getPISUserList');

            action.setParams({
                pisuserIds: pisuserIds
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let recordUi = component.get('v.notificationRecordUi');
                    let pisuserList = response.getReturnValue();

                    fields.forEach(function (field) {
                        let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
                        if (id && pisuserList[id]) {
                            recordUi.record.fields[field].displayValue = pisuserList[id].ENFIRSTNAME__c + ' ' + pisuserList[id].ENLASTNAME__c
                        }
                    });

                    component.set('v.notificationRecordUi', recordUi);
                } else if (state === 'ERROR') {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error('Error message: ' + errors[0].message);
                        }
                    } else {
                        console.log('Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    getFunctionalLocations: function (component, event, helper) {
        let recordUi = component.get('v.notificationRecordUi');

        let fields = [
            'Functional_Location__c'
        ];

        let flIds = [];
        fields.forEach(function (field) {
            let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
            id && flIds.push(id);
        });

        if (flIds.length > 0) {
            let action = component.get('c.getFunctionalLocationList');

            action.setParams({
                flIds: flIds
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let recordUi = component.get('v.notificationRecordUi');
                    let flList = response.getReturnValue();

                    fields.forEach(function (field) {
                        let id = recordUi.record.fields[field] ? recordUi.record.fields[field].value : null;
                        if (id && flList[id]) {
                            recordUi.record.fields[field].displayValue = flList[id].Description__c
                        }
                    });

                    component.set('v.notificationRecordUi', recordUi);
                } else if (state === 'ERROR') {
                    let errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.error('Error message: ' + errors[0].message);
                        }
                    } else {
                        console.log('Unknown error');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
});