({
    checkAbleVerify: function (component, event) {
        let recordId = component.get('v.recordId');
        if (recordId) {
            let action = component.get('c.checkAbleVerify');
            
            action.setParams({
                workclearanceId: recordId
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    var result =  response.getReturnValue();
                    component.set('v.color', result);
                    // alert('color: ' + result);
                    if (result == 'yellow') {
                        component.set('v.disableVerify', false);
                        // alert(color);
                        this.applyVerificationCSS(component, event, result);
                        //this.checkVerification(comopnent,event);

                        // Inpection Button
                        //component.set('v.disableInspec', true);
                    } else if (result == 'green') {
                        // alert('colorGreen: ' + result);

                        component.set('v.isGreen', true);

                        result = 'graygreen';
                        this.applyVerificationCSS(component, event, result);

                        // Inpection Button
                        //component.set('v.disableInspec', false);
                    } else if (result == 'red') {
                        this.applyVerificationCSS(component, event, result);

                        // Inpection Button
                        //component.set('v.disableInspec', true);
                    } else {
                        component.set('v.disableVerify', true);
                        let THIS = this;
                        setTimeout(function() {
                            THIS.applyVerificationCSS(component, event, '');
                        }, 0);
                        // Inpection Button
                        //component.set('v.disableInspec', true);
                    }
                    this.checkInspectionStatus(component, event);
                    
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
    checkInspectionStatus: function (component, event) {
        let action = component.get('c.checkInspectionStatus');
        let THIS = this;
        console.log('checkInspectionStatus : action >',action);
        action.setParams({
            workclearanceId: component.get('v.recordId'),
        });
        action.setCallback(this, function(response){
            let state = response.getState();
            
            if (state === 'SUCCESS') {
                var result =  response.getReturnValue();
                console.log('checkInspectionStatus : result >',result);
                if (result == 'ดำเนินการได้') {
                    component.set('v.disableInspec', false);
                    setTimeout($A.getCallback(function() {
                        THIS.applyInspectionCSS(component, event, 'green');
                    }, 0));
                } else if (result == 'หยุดงานชั่วคราว') {
                    component.set('v.disableInspec', false);
                    setTimeout($A.getCallback(function() {
                        THIS.applyInspectionCSS(component, event, 'yellow');
                    }, 0));
                } else if (result == 'หยุดงานถาวร') {
                    component.set('v.disableInspec', false);
                    setTimeout($A.getCallback(function() {
                        THIS.applyInspectionCSS(component, event, 'red');
                    }, 0));
                } else if (result == 'Draft') {
                    component.set('v.disableInspec', false);
                    setTimeout($A.getCallback(function() {
                        THIS.applyInspectionCSS(component, event, 'gray');
                    }, 0));
                } else {
                    component.set('v.disableInspec', true);
                    setTimeout($A.getCallback(function() {
                        THIS.applyInspectionCSS(component, event, '');
                    }, 0));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    
    handleAgreeDisagree : function (component, event) {
        let recordId = component.get('v.recordId');
        console.log('wcId: ' + recordId);
        let action = component.get('c.checkAgreeDisagree');
        
        action.setParams({
            workClearanceId: recordId
        });
        
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                var result =  response.getReturnValue();
                console.log(result);
                // alert('handleAgreeDisagree'+ result);
                var color = '';
                if (result == false){ 
                    component.set('v.isGreen',false);
                    component.set('v.openDisgreeModal',true);
                    // var color = 'red';
                    // alert(color);
                    // this.applyVerificationCSS(component,event,color);
                    // this.checkVerification(comopnent,event);
                }
                else{
                    // component.set('v.disableVerify',false);
                    var isGreen  = false
                    component.set('v.isGreen',true);
                    // alert(component.get('v.isGreen')+'GREEN');
                    
                    var color ='green';
                    // alert('handleAgreeDisagree ' + color);
                    this.applyVerificationCSS(component,event,color);
                    
                    var isYellow = 'yellow';
                    component.set('v.isYellow', true);
                    
                    this.applyInspectionCSS(component,event,isYellow);
                    
                    
                }
                
                
            } else if (state === 'ERROR') {
                let errors = response.getError();
                
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error('Error message: ' + errors[0].message);
                    }
                } 
                else {
                    console.log('Unknown error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    /*
    checkAbleInspec: function (component, event) {
        let recordId = component.get('v.recordId');
        if (recordId) {
            let action = component.get('c.checkAbleInspec');
            
            action.setParams({
                workclearanceId: recordId
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    var result =  response.getReturnValue();
                    var color = '';
                    if (result == true){ 
                        component.set('v.disableInspec',false);
                        var color = 'yellow';
                        // alert(cInspection
                        this.applyInspectionCSS(component,event,color);
                        //this.checkVerification(comopnent,event);
                    }
                    else{
                        component.set('v.disableInspec',true);
                    }
                    
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
    },*/
    
    applyVerificationCSS: function(component, event, color) {
        
        // var cmpTarget = cmp.find('tab-button');
        var cmpTarget = component.find('verificationButton');
        // alert('handlegreen----'+color);
        if (color == 'yellow') {//gray -> yellow
            // alert('handleyellow----'+color);
            $A.util.removeClass(cmpTarget, 'tab-button-inactive');
            // alert(component.get('v.whichPage'));

            $A.util.addClass(cmpTarget, 'tab-button-active');
        }
        else if (color == 'green') {//yellow -> green
            // alert('handlegreen----'+color);
            // $A.util.removeClass(cmpTarget, 'tab-button-disagree');
            $A.util.removeClass(cmpTarget, 'tab-button-active');
            $A.util.removeClass(cmpTarget, 'tab-button-disagree');

            $A.util.addClass(cmpTarget, 'tab-button');
        }

        else if (color == 'graygreen') {//yellow -> green
            // alert('handlegraygreen----'+color);
            $A.util.removeClass(cmpTarget, 'tab-button-disagree');
            $A.util.removeClass(cmpTarget, 'tab-button-inactive');
            // alert(component.get('v.whichPage'));

            $A.util.addClass(cmpTarget, 'tab-button');
        }
        else if (color == 'red') { //yellow -> red
            // alert('handlered----'+color);
            $A.util.removeClass(cmpTarget, 'tab-button-active');
            // alert(component.get('v.whichPage'));

            $A.util.addClass(cmpTarget, 'tab-button-disagree');
        }
        else if (color == 'redgreen') { //red -> green
            alert('handleredgreen----' + color);
            $A.util.removeClass(cmpTarget, 'tab-button-disagree');
            // alert(component.get('v.whichPage'));

            $A.util.addClass(cmpTarget, 'tab-button-active');
        }

        let whichPage = component.get('v.whichPage');
        if (whichPage == 'verification') {
            let btnDetail = component.find('detailButton');
            let btnVerification = component.find('verificationButton');
            let btnInspection = component.find('inspectionButton');
            $A.util.removeClass(btnDetail, 'focusBtnOnCurrentPage'); 
            $A.util.removeClass(btnInspection, 'focusBtnOnCurrentPage'); 
            $A.util.addClass(btnVerification, 'focusBtnOnCurrentPage');
        }
        
    },
    applyInspectionCSS: function(component, event, color) {
        let cmpTarget = component.find('inspectionButton');
        if (color == 'yellow') {
            $A.util.removeClass(cmpTarget, 'tab-button-inactive'); 
            $A.util.removeClass(cmpTarget, 'tab-button-disagree');
            $A.util.removeClass(cmpTarget, 'tab-button'); 
            $A.util.addClass(cmpTarget, 'tab-button-active');
            //component.set('v.disableInspec',false);
            //component.set('v.checkColorInspecBtn','yellow');
        } else if (color == 'green') {
            $A.util.removeClass(cmpTarget, 'tab-button-inactive'); 
            $A.util.removeClass(cmpTarget, 'tab-button-active'); 
            $A.util.removeClass(cmpTarget, 'tab-button-disagree');
            $A.util.addClass(cmpTarget, 'tab-button');
            //component.set('v.disableInspec',false);
            //component.set('v.checkColorInspecBtn','green');
        } else if (color == 'red') {
            $A.util.removeClass(cmpTarget, 'tab-button-inactive'); 
            $A.util.removeClass(cmpTarget, 'tab-button-active');
            $A.util.removeClass(cmpTarget, 'tab-button'); 
            $A.util.addClass(cmpTarget, 'tab-button-disagree');
            //component.set('v.disableInspec',false);
            //component.set('v.checkColorInspecBtn','red');
        } else if (color == 'gray') {
            $A.util.removeClass(cmpTarget, 'tab-button-active');
            $A.util.removeClass(cmpTarget, 'tab-button-disagree'); 
            $A.util.removeClass(cmpTarget, 'tab-button'); 
            $A.util.addClass(cmpTarget, 'tab-button-inactive');
            //component.set('v.disableInspec',false);
            //component.set('v.checkColorInspecBtn','gray');
        } else {
            component.set('v.disableInspec', true);
        }

        let whichPage = component.get('v.whichPage');
        if (whichPage == 'Inspection') {
            let btnDetail = component.find('detailButton');
            let btnVerification = component.find('verificationButton');
            let btnInspection = component.find('inspectionButton');
            $A.util.removeClass(btnDetail, 'focusBtnOnCurrentPage'); 
            $A.util.removeClass(btnVerification, 'focusBtnOnCurrentPage'); 
            $A.util.addClass(btnInspection, 'focusBtnOnCurrentPage');
        }
        
//        // var cmpTarget = cmp.find('tab-button');
//        var cmpTarget = component.find('inspectionButton');
//        if (color == 'yellow'){//gray -> yellow
//            $A.util.removeClass(cmpTarget, 'tab-button-inactive'); 
//            // alert(component.get('v.whichPage'));
//            
//            $A.util.addClass(cmpTarget, 'tab-button-active');
//            component.set('v.disableInspec',false);
//            // alert('disableInspec---'+component.get('v.disableInspec'));
//            //component.set('v.color','green');
//        }
//        else if (color == 'green'){//yellow -> green
//            $A.util.removeClass(cmpTarget, 'tab-button-inactive');
//            // alert(component.get('v.whichPage'));
//            
//            $A.util.addClass(cmpTarget, 'tab-button');
//        }
//            else if (color == 'red'){ //yellow -> red
//                $A.util.removeClass(cmpTarget, 'tab-button-active');
//                // alert(component.get('v.whichPage'));
//                
//                $A.util.addClass(cmpTarget, 'tab-button-disagree');
//            }
        
    },
    handleSetTimeout: function (component) {
        var timeout = window.setTimeout(
            $A.getCallback(() => {
                console.warn('Timeout');
                if (
                component.get('v.workClearanceRecord.Integration_Status__c') === 'In Progress' &&
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
                            component.get('v.workClearanceRecord.Integration_Status__c') &&
                            component.get('v.workClearanceRecord.Integration_Status__c') === 'In Progress'
                            ) {
                            component.find('recordData').reloadRecord(true);
                        } else if (
                                       component.get('v.interval') &&
                        component.find('recordData') &&
                        component.get('v.workClearanceRecord.Integration_Status__c') !== 'In Progress'
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
                           hasWriteAccess: function (component) {
            let recordId = component.get('v.recordId');
        
        if (recordId) {
            let action = component.get('c.hasWriteAccess');
            
            action.setParams({
                workclearanceId: recordId
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
    canApproveOrReject: function (component) {
        let recordId = component.get('v.recordId');

        if (recordId) {
            let action = component.get('c.canApproveOrReject');

            action.setParams({
                workclearanceId: recordId
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.canApproveOrReject', response.getReturnValue());
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
    truncHistoryDetail: function (component) {
        let workClearanceRecord = component.get('v.workClearanceRecord');
        if (workClearanceRecord) {
        }
    },
    getPISUsers: function (component, event, helper) {
        let recordUi = component.get('v.workClearanceRecordUi');
        
        let fields = [
            'AGT_UI__c',
            'Rejected_By__c',
            'Requester_UI__c',
            'Thaioil_Supervisor_Indicator_UI__c',
            'Authorized_Signature_UI__c',
            'Authorized_Signatory_UI__c',
            'Close_Applicant_or_Bearer_UI__c',
            'Close_Authorized_Sign_Indc__c',
            'Close_Authorized_Sign_off_UI__c',
            'Extend_Applicant_or_Bearer_UI__c',
            'Extend_Authorized_Sign_UI__c'
        ];
        
        let pisuserIds = [];
        fields.forEach(function (field) {
            let id = recordUi.fields[field] ? recordUi.fields[field].value : null;
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
                    try {
                        let recordUi = component.get('v.workClearanceRecordUi');
                        recordUi = JSON.parse(JSON.stringify(recordUi));
                        
                        let pisuserList = response.getReturnValue();
                        
                        fields.forEach(function (field) {
                            let id = recordUi.fields[field] ? recordUi.fields[field].value : null;
                            if (id && pisuserList[id]) {
                                recordUi.fields[field].displayValue = pisuserList[id].ENFIRSTNAME__c + ' ' + pisuserList[id].ENLASTNAME__c
                            }
                        });
                        
                        component.set('v.workClearanceRecordUi', recordUi);
                        
                        helper.getApplicantOrBearers(component, event, helper);
                    } catch(ex) {
                        console.error(ex.message);
                    }
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
    getApplicantOrBearers: function (component, event, helper) {
        let recordUi = component.get('v.workClearanceRecordUi');
        
        let fields = [
            'Applicant_or_Bearer_UI__c',
            'Bearer1_UI__c',
            'Bearer2_UI__c',
            'Bearer3_UI__c',
            'Bearer4_UI__c'
        ];
        
        let bearerIds = [];
        fields.forEach(function (field) {
            let id = recordUi.fields[field] ? recordUi.fields[field].value : null;
            id && bearerIds.push(id);
        });
        
        if (bearerIds.length > 0) {
            let action = component.get('c.getApplicantOrBearerList');
            
            action.setParams({
                bearerIds: bearerIds
            });
            
            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let recordUi = component.get('v.workClearanceRecordUi');
                    let bearerList = response.getReturnValue();
                    
                    fields.forEach(function (field) {
                        let id = recordUi.fields[field] ? recordUi.fields[field].value : null;
                        if (id && bearerList[id]) {
                            recordUi.fields[field].displayValue = bearerList[id].Description__c
                        }
                    });
                    
                    component.set('v.workClearanceRecordUi', recordUi);
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
    hasPendingApproval: function (component, event, helper) {
        let hasPendingApproval = false;
        let recordUi = component.get('v.workClearanceRecordUi');
        
        let System_Status__c = recordUi.fields.System_Status__c.value;
        let User_Status__c = recordUi.fields.User_Status__c.value;
        let Integration_Status__c = recordUi.fields.Integration_Status__c.value;
        let Extend_No__c = recordUi.fields.Extend_No__c.value;
        let Authorized_Signature_UI__c = recordUi.fields.Authorized_Signature_UI__c.value;
        let Authorized_Signatory_UI__c = recordUi.fields.Authorized_Signatory_UI__c.value;
        let Close_Applicant_or_Bearer_UI__c = recordUi.fields.Close_Applicant_or_Bearer_UI__c.value;
        let Close_Authorized_Sign_off_UI__c = recordUi.fields.Close_Authorized_Sign_off_UI__c.value;
        let Extend_Applicant_or_Bearer_UI__c = recordUi.fields.Extend_Applicant_or_Bearer_UI__c.value;
        let Extend_Authorized_Sign_UI__c = recordUi.fields.Extend_Authorized_Sign_UI__c.value;
        
        if (
            System_Status__c &&
            System_Status__c.includes('PREP') &&
            //System_Status__c.includes('CLSD') &&
            User_Status__c &&
            User_Status__c.includes('WCCL') &&
            Close_Applicant_or_Bearer_UI__c &&
            !Close_Authorized_Sign_off_UI__c
        ) {
            hasPendingApproval = true;
        } else if (
            System_Status__c === 'PREP' &&
            User_Status__c &&
            User_Status__c.includes('EXTD') &&
            Extend_No__c &&
            Number(Extend_No__c) > 0 &&
            Authorized_Signature_UI__c && 
            !Authorized_Signatory_UI__c
        ) {
            hasPendingApproval = true;
        } else if (
            System_Status__c === 'PREP' &&
            User_Status__c &&
            User_Status__c.includes('WIP1') &&
            Close_Applicant_or_Bearer_UI__c &&
            !Close_Authorized_Sign_off_UI__c
        ) {
            hasPendingApproval = true;
        } else if (
            
            System_Status__c === 'PREP' &&
            Extend_Applicant_or_Bearer_UI__c &&
            !Extend_Authorized_Sign_UI__c
        ) {
            hasPendingApproval = true;
        } else if (
            System_Status__c = 'CRTE' &&
            !Authorized_Signature_UI__c && 
            !Authorized_Signatory_UI__c
        ) {
            hasPendingApproval = true;
        }
        
        component.set('v.hasPendingApproval', hasPendingApproval);
    },
});