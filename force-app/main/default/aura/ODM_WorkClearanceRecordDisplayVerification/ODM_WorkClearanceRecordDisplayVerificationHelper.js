({
    constants: {
        'DATA_TYPE': {
            'TEXT': 'Text',
            'TEXT_AREA': 'Text Area',
            'PICKLIST': 'Picklist',
            'LOOKUP': 'Lookup',
        }
    },
    canEditOrSubmit: function (component) {
        let recordId = component.get('v.recordId');

        if (recordId) {
            let action = component.get('c.canEditOrSubmit');

            action.setParams({
                workclearanceId: recordId
            });

            action.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    component.set('v.canEditOrSubmit', response.getReturnValue());
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
    getFormQuestions: function (component, event, helper) {
        let version = '';
        let action = component.get('c.getFormQuestions');
        // alert('id: ' + component.get('v.recordId'));

        action.setParams({
            'version': version
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let results = response.getReturnValue();
                let formQuestions = [];
                // alert('results' + JSON.stringify(results));
                let versions = [];
                let sections = [];
                let dataTypes = [];

                if ($A.util.isArray(results) && results.length > 0) {
                    results.forEach(function (value) {
                        if (String(value.Answer_type__c) === helper.constants.DATA_TYPE.PICKLIST) {
                            let options = !$A.util.isEmpty(value.Value__c) && String(value.Value__c).split(',');
                            value.Picklist = options || [];
                        }
                        //new
                        if (String(value.Answer_type__c) === helper.constants.DATA_TYPE.LOOKUP) {

                            value.Answer__c = component.get('v.PISUser');
                            console.log('getFormQuestions - value.Answer__c >>>>', value.Answer__c);
                        }

                        formQuestions.push(value);
                    });

                    component.set('v.formQuestions', formQuestions);
                    component.set('v.versions', helper.getVersions(formQuestions).reverse());
                    component.set('v.sections', helper.getSections(formQuestions));
                    component.set('v.dataTypes', helper.getDataTypes(formQuestions));
                    component.set('v.version', component.get('v.versions')[0]);

                    console.log('Version:' + JSON.stringify(component.get('v.versions')));
                    console.log('Sec:' + JSON.stringify(component.get('v.sections')));
                    console.log('type:' + JSON.stringify(component.get('v.dataTypes')));
                    console.log('formQuestionL' + JSON.stringify(component.get('v.formQuestions')));

                }
            }
        });

        $A.enqueueAction(action);
    },
    getFormAnswers: function (component, event, helper) {
        let action = component.get('c.getFormAnswers');
        // alert('id: ' + component.get('v.recordId'));
        console.log('id: ' + component.get('v.recordId'));
        action.setParams({
            'workClearanceId': component.get('v.recordId')
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let formAnswers = response.getReturnValue();
                // alert(JSON.stringify('formAnswers' + formAnswers));
                console.log('formAnswers: ' + JSON.stringify(formAnswers));
                if ($A.util.isArray(formAnswers) && formAnswers.length > 0) {
                    let PTWHeaderId = formAnswers[0].Id;
                    component.set('v.PTWHeaderId', PTWHeaderId);
                    if (PTWHeaderId != '') {
                        component.set('v.selectedFormQuestions', PTWHeaderId);
                    }
                    component.set('v.formAnswers', formAnswers);
                }
                helper.displaySelectedFormQuestions(component, event, helper);

            }
        });

        $A.enqueueAction(action);
    },
    getPISUser: function (component, event, helper) {
        let action = component.get('c.getPISUser');

        action.setParams({
            workClearanceId: component.get('v.recordId') //recordId จากหน้า Ui saleforce
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let results = response.getReturnValue();
                if ($A.util.isArray(results) && results.length > 0) {

                    component.set('v.PISUser', results[0].EN_Fullname__c);
                    console.log('PISUser >>>>>', component.get('v.PISUser'));
                }

            }
        });

        $A.enqueueAction(action);
    },
    displaySelectedFormQuestions: function (component, event, helper) {
        // alert('mdaolAnwer: ' + component.get('v.modalAnswer'));
        let formQuestions = component.get('v.formQuestions');
        let formAnswers = component.get('v.formAnswers');
        let ptwHeaderId = component.get('v.selectedFormQuestions');
        console.log('ptwHeaderIddisplay' + (JSON.stringify(ptwHeaderId)));
        let formAnswer = formAnswers.find((value) => value.Id == ptwHeaderId);
        console.log('formAnswersIndisplay' + (JSON.stringify(formAnswers)));
        if (formAnswer) {
            let version = formAnswer.Version__c;
            let formVersionQuestion = formQuestions.filter((value) => value.Version__c == version);
            formVersionQuestion = JSON.parse(JSON.stringify(formVersionQuestion));
            component.set('v.displayedFormQuestions', formVersionQuestion);

            let action_wc = component.get('c.getWorkClearanceDetail');
            // alert('id: ' + component.get('v.recordId'));
            console.log('id: ' + component.get('v.recordId'));
            action_wc.setParams({
                'workClearanceId': component.get('v.recordId')
            });

            action_wc.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let wc_detail = response.getReturnValue();

                    formVersionQuestion.forEach(function (q) {
                        let answer = (formAnswer.PTW_Answer__r) ? formAnswer.PTW_Answer__r.find((a) => q.Id == a.Question__c) : false;
                        q.PTW_Header__c = ptwHeaderId;
                        q.Answer__c = (answer) ? answer.Answer__c : '';
                        if (q.Order_Question__c == 11) {
                            if (component.get('v.modalAnswer') == '' || component.get('v.modalAnswer') == null || component.get('v.modalAnswer') == undefined) {
                                q.Answer__c = '';
                            }
                            else {
                                q.Answer__c = component.get('v.modalAnswer');
                            }
                        }
                        if (q.Order_Question__c == 1) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 2) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 3) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 4) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 5) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                            component.set('v.highRiskWorkType', wc_detail[q.Order_Question__c - 1]);
                        }
                        if (q.Order_Question__c == 10) {
                            component.set('v.status', q.Answer__c);
                        }
                    });

                    component.set('v.disableSaveDraft', wc_detail[5] == 'Agree' || wc_detail[5] == 'Disagree');
                    component.set('v.displayedFormQuestions', formVersionQuestion);
                    component.set('v.sections', helper.getSections(formVersionQuestion));

                    helper.checkIsValidRequireFields(component, event, helper);
                }

            });
            $A.enqueueAction(action_wc);


        } else {
            let version = component.get('v.version') || 1;
            let workClearanceId = component.get('v.recordId');
            let formVersionQuestion = formQuestions.filter((value) => value.Version__c == version);
            formVersionQuestion = JSON.parse(JSON.stringify(formVersionQuestion));
            component.set('v.displayedFormQuestions', formVersionQuestion);

            let action_wc = component.get('c.getWorkClearanceDetail');
            // alert('id: ' + component.get('v.recordId'));
            console.log('id: ' + component.get('v.recordId'));
            action_wc.setParams({
                'workClearanceId': component.get('v.recordId')
            });

            action_wc.setCallback(this, function (response) {
                let state = response.getState();
                if (state === 'SUCCESS') {
                    let wc_detail = response.getReturnValue();

                    formVersionQuestion.forEach(function (q) {

                        q.Work_Clearance__c = workClearanceId;
                        if (q.Order_Question__c == 11) {
                            if (component.get('v.modalAnswer') == '' || component.get('v.modalAnswer') == null || component.get('v.modalAnswer') == undefined) {
                                q.Answer__c = '';
                            }
                            else {
                                q.Answer__c = component.get('v.modalAnswer');
                            }
                        }
                        if (q.Order_Question__c == 1) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 2) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 3) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 4) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                        }
                        if (q.Order_Question__c == 5) {
                            q.Answer__c = wc_detail[q.Order_Question__c - 1];
                            component.set('v.highRiskWorkType', wc_detail[q.Order_Question__c - 1]);
                        }
                        if (q.Order_Question__c == 10) {
                            component.set('v.status', q.Answer__c);
                        }
                        if (q.Question_API__c == 'EQUIPMENT_VERIFICATION' && component.get('v.highRiskWorkType') == 'งานทั่วไป') {
                            q.Answer__c = 'Agree';
                        }
                        if (q.Question_API__c == 'PERSON_VERIFICATION' && component.get('v.highRiskWorkType') == 'งานทั่วไป') {
                            q.Answer__c = 'Agree';
                        }
                        //new
                        if (q.Answer_type__c == helper.constants.DATA_TYPE.LOOKUP) {
                            console.log('displaySelectedFormQuestions - component.get(v.PISUser) >>>', component.get('v.PISUser'));
                            q.Answer__c = component.get('v.PISUser');
                            console.log('displaySelectedFormQuestions - q.Answer__c >>>', q.Answer__c);
                        }
                    });
                    component.set('v.displayedFormQuestions', formVersionQuestion);
                    component.set('v.sections', helper.getSections(formVersionQuestion));

                    helper.checkIsValidRequireFields(component, event, helper);
                }

            });
            $A.enqueueAction(action_wc);
            /*
            formVersionQuestion.forEach(function (q) {
                q.Work_Clearance__c = workClearanceId;
                if (q.Order_Question__c == 11 && component.get('v.modalAnswer')){
                    q.Answer__c = component.get('v.modalAnswer');
                }
            });
            component.set('v.displayedFormQuestions', formVersionQuestion);
            component.set('v.sections', helper.getSections(formVersionQuestion));*/
        }

        console.log(component.get('v.displayedFormQuestions'));
    },
    submitPermitToWork: function (component, event, helper) {
        // alert('Submit')
        let displayedFormQuestions = component.get('v.displayedFormQuestions');
        let status = component.get('v.status');

        // alert('status---'+status);
        let formName = component.get('v.formName');
        let action = component.get('c.savePermitToWork');
        console.log('submitDisplsy: ' + JSON.stringify(displayedFormQuestions));
        let findHeader = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.PTW_Header__c));
        let headerId = (findHeader) ? findHeader.PTW_Header__c : '';
        let findWorkClearance = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Work_Clearance__c));
        //let workClearanceId = (findWorkClearance) ? findWorkClearance.Work_Clearance__c : '';
        let workClearanceId = component.get('v.recordId');
        let findVersion = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Version__c));
        let version = (findVersion) ? findVersion.Version__c : '';
        // alert('in  submit permit');
        action.setParams({
            'jsonAnswer': JSON.stringify({
                'HeaderId': headerId,
                'WorkClearanceId': workClearanceId,
                'Version': version,
                'FormName': formName,
                'Status': status,
                'Verification': displayedFormQuestions
            })
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let submitResult = response.getReturnValue();
                //  alert('submitResult---' + JSON.stringify(submitResult));
                component.set('v.selectedFormQuestions', submitResult);
                // alert('component.get(v.modalAnswer)---' + component.get('v.modalAnswer'));
                // component.set('v.selectedFormQuestions', saveResults);
                // helper.getFormAnswers(component, event, helper);
                if (component.get('v.modalAnswer') == "") {
                    var appEvent = $A.get("e.c:ODM_WorkClearanceVerificationSubmit")
                    appEvent.setParams({ "message": "saved" });
                    appEvent.fire();
                }

                // if (submitResult){
                //     component.set('v.isDisagreeModalOpen', false);
                // }
                // else{
                //     component.set('v.isDisagreeModalOpen',  true);
                // }

                helper.showToast('success', 'Success', 'Permit to Work has been saved, successfully');
                this.getFormAnswers(component, event, helper);

                var compEvent = component.getEvent("sampleComponentEvent");
                compEvent.setParams({ "message": "Static Text" });
                compEvent.fire();
                helper.closeReasonForDisagreeModal(component, event, helper);
            } else if (state === 'ERROR') {
                let error = response.getError();
                let errorMessage = '';
                error.forEach(function (value) {
                    for (let i in value.fieldErrors) {
                        errorMessage += `Field Error: ${i}, Error Code: ${value.fieldErrors[i][0].statusCode}, Error Message: ${value.fieldErrors[i][0].message}`
                    }
                });
                helper.showToast('error', 'Cannot save Permit to Work Inspection, Please contact System Administrator.', `${errorMessage}`)
            }
        });

        $A.enqueueAction(action);
    },
    savePermitToWork: function (component, event, helper) {
        let displayedFormQuestions = component.get('v.displayedFormQuestions');
        for (var i = 0; i < displayedFormQuestions.length; i++) {
            let eachAnswer = displayedFormQuestions[i];
            if (eachAnswer.Order_Question__c == 10) {
                eachAnswer.Answer__c = 'Draft';
            }
        }
        let status = component.get('v.status');

        let formName = component.get('v.formName');
        let action = component.get('c.submitPermitToWork');
        let findHeader = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.PTW_Header__c));
        let headerId = (findHeader) ? findHeader.PTW_Header__c : '';
        let findWorkClearance = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Work_Clearance__c));
        //let workClearanceId = (findWorkClearance) ? findWorkClearance.Work_Clearance__c : '';
        let workClearanceId = component.get('v.recordId');
        //('test---'+workClearanceId);
        let findVersion = displayedFormQuestions.find((value) => !$A.util.isEmpty(value.Version__c));
        let version = (findVersion) ? findVersion.Version__c : '';

        action.setParams({
            'jsonAnswer': JSON.stringify({
                'HeaderId': headerId,
                'WorkClearanceId': workClearanceId,
                'Version': version,
                'FormName': formName,
                'Status': status,
                'Verification': displayedFormQuestions
            })
        });

        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === 'SUCCESS') {
                let saveResults = response.getReturnValue();
                // alert('saveResults' + JSON.stringify(saveResults));
                console.log('saveResults' + JSON.stringify(saveResults));
                component.set('v.selectedFormQuestions', saveResults);
                helper.showToast('success', 'Success', 'Permit to Work has been saved, successfully');
                helper.getFormAnswers(component, event, helper);
            } else if (state === 'ERROR') {
                let error = response.getError();
                let errorMessage = '';
                error.forEach(function (value) {
                    for (let i in value.fieldErrors) {
                        errorMessage += `Field Error: ${i}, Error Code: ${value.fieldErrors[i][0].statusCode}, Error Message: ${value.fieldErrors[i][0].message}`
                    }
                });
                helper.showToast('error', 'Cannot save Permit to Work Inspection, Please contact System Administrator.', `${errorMessage}`)
            }
        });

        $A.enqueueAction(action);
    },
    getVersions: function (formQuestions) {
        let versions = [];
        formQuestions.forEach((value) => { versions.push(value.Version__c) });
        return versions.filter((value, index, self) => self.indexOf(value) === index);
    },
    getSections: function (formQuestions) {
        let sections = [];
        formQuestions.forEach((value) => { sections.push(value.Section__c) });
        return sections.filter((value, index, self) => self.indexOf(value) === index);
    },
    getDataTypes: function (formQuestions) {
        let dataTypes = [];
        formQuestions.forEach((value) => { dataTypes.push(value.Answer_type__c) });
        return dataTypes.filter((value, index, self) => self.indexOf(value) === index);
    },

    applyVerificationCSS: function (component, event, color) {

        //  var cmpTarget = cmp.find('tab-button');

        // var cmpTarget = component.find('verificationButton');
        // if (color == 'yellow'){//gray -> yellow
        //     // $A.util.removeClass(cmpTarget, 'tab-button-inactive'); 
        //     // // alert(component.get('v.whichPage'));

        //     // $A.util.addClass(cmpTarget, 'tab-button-active');
        // }
        // else if (color == 'green'){//yellow -> green
        //     // $A.util.removeClass(cmpTarget, 'tab-button-active');
        //     // // alert(component.get('v.whichPage'));

        //     // $A.util.addClass(cmpTarget, 'tab-button');
        // }
        // else if (color == 'red'){ //yellow -> red
        //     $A.util.removeClass(cmpTarget, 'tab-button-active');
        //     // alert(component.get('v.whichPage'));

        //     $A.util.addClass(cmpTarget, 'tab-button-disagree');
        // }


    },
    invokeChildMethod: function (component) {
        // find the child component
        const myChildComponent = component.find("myChildComponent");

        // invoke a method on the child component
        const response = myChildComponent.getData();
    },
    showToast: function (type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            mode: 'dismissible',
            duration: 10000,
            title: title,
            message: message,
            type: type,
        });
        toastEvent.fire();
    },
    checkIsValidRequireFields: function (component, event, helper) {
        let displayedFormQuestions = component.get('v.displayedFormQuestions');
        let isValidRequiredField = true;
        displayedFormQuestions.forEach(function (value) {
            if (value.Order_Question__c == 6 ||
                value.Order_Question__c == 7 ||
                value.Order_Question__c == 8)
            {
                isValidRequiredField = isValidRequiredField && !$A.util.isEmpty(value.Answer__c);
            }
        });
        component.set('v.isValidRequiredField', isValidRequiredField);
    },
    showReasonForDisagreeModal: function(component, event, helper) {
        component.set("v.isDisagreeModalOpen", true);
    },
    closeReasonForDisagreeModal: function(component, event, helper) {
        component.set("v.isDisagreeModalOpen", false);
    },
    checkReasonForDisagreeIsBlank: function(component, event, helper) {
        return $A.util.isEmpty(component.get("v.modalAnswer"));
    },
    checkStatusAnswer: function(component, event, helper) {
        let displayedFormQuestions = component.get('v.displayedFormQuestions');
        let workingArea = false;
        let equipment = false;
        let person = false;
        for (var i = 0; i < displayedFormQuestions.length; i++) {
            let eachAnswer = displayedFormQuestions[i];
            if (String(eachAnswer.Answer__c).toLowerCase() != 'agree') {
                continue;
            }

            if (eachAnswer.Question_API__c == 'WORKING_AREA_VERIFICATION') {
                workingArea = true;
            }
            if (eachAnswer.Question_API__c == 'EQUIPMENT_VERIFICATION') {
                equipment = true;
            }
            if (eachAnswer.Question_API__c == 'PERSON_VERIFICATION') {
                person = true;
            }
        }
        return (workingArea && equipment && person) ? 'Agree' :  'Disagree';
    },
})