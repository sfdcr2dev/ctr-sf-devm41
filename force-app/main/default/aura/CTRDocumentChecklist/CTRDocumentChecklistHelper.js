({
    closeModal: function (component) {
        $A.get("e.force:closeQuickAction").fire();
        component.set("v.isModalOpen", false);
    },

    getDocChecklist: function (component) {
        var action = component.get('c.getDocChecklistInfo');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "templateType": component.get('v.templateType'),
        });
        console.log(component.get('v.recordId'));
        console.log(component.get('v.templateType'));

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var docChecklist = response.getReturnValue();
                console.log('doc checklist ',docChecklist)
                component.set('v.selectedEmailCC', docChecklist.CustomerEmailCC__c);
                component.set('v.uploadedFile', docChecklist.CustomerAttachment__c);
                console.log('v.uploadedFile', component.get('v.uploadedFile'));
                var recordType = docChecklist.RecordType.Name;
                console.log('recordType Name :' + recordType);
                console.log('CreditOwnerSectionHead__c :' + docChecklist.CreditOwnerSectionHead__c);
                component.set("v.TRCRHead", docChecklist.CreditOwnerSectionHead__c);
                var isTRCR = docChecklist.isTRCR__c;
                if (isTRCR == 'true') {
                    this.setRecordType(component, recordType);
                    this.getMailApprovalReport(component, docChecklist);
                    this.handleOnChange(component, docChecklist);
                }
                else {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "title": "Error!",
                        "message": "Do not have permission",
                        "type": "error"
                    });
                    toastEvent.fire();

                    $A.get("e.force:closeQuickAction").fire();
                    component.set("v.isModalOpen", false);
                }
                
                
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getMailApprovalReport: function (component, docChecklist) {
        component.set('v.emailInfo.Subject__c', docChecklist.CustomerSubject__c);
        if(docChecklist.BusinessUnit__c == 'TX') {
            component.set('v.emailInfo.EmailTo__c', docChecklist.OwnerEmail__c); // trader
        } else {
            component.set('v.emailInfo.EmailTo__c', docChecklist.CTRRequestFormHeader__r.Email__c); //customer
        }
        component.set('v.emailInfo.EmailCC__c', docChecklist.CustomerEmailCC__c);
        component.set('v.emailInfo.Message__c', docChecklist.CustomerMessage__c);

        console.log('v.emailInfo.Subject__c', component.get('v.emailInfo.Subject__c'));
        console.log('v.emailInfo.EmailTo__c', component.get('v.emailInfo.EmailTo__c'));
        console.log('v.emailInfo.EmailCC__c', component.get('v.emailInfo.EmailCC__c'));
        console.log('v.emailInfo.Message__c', component.get('v.emailInfo.Message__c'));
    },

    // setDocChecklist: function (component, fields) {
    //     component.set('v.docChecklistObj.Id', component.get('v.recordId'));
    //     component.set('v.docChecklistObj.HasCOI__c', fields['HasCOI__c']);
    //     component.set('v.docChecklistObj.HasMOA__c', fields['HasMOA__c']);
    //     component.set('v.docChecklistObj.hasAuditedFinalcial__c', fields['hasAuditedFinalcial__c']);
    //     component.set('v.docChecklistObj.HasShareHolders__c', fields['HasShareHolders__c']);
    //     component.set('v.docChecklistObj.HasCertofVATRegistration__c', fields['HasCertofVATRegistration__c']);
    //     component.set('v.docChecklistObj.HasRegistrationIssue__c', fields['HasRegistrationIssue__c']);
    //     component.set('v.docChecklistObj.HasPowerofAttorney__c', fields['HasPowerofAttorney__c']);
    //     component.set('v.docChecklistObj.HasOtherDocument__c', fields['HasOtherDocument__c']);
    //     component.set('v.docChecklistObj.ListOtherDocument__c', fields['ListOtherDocument__c']);
    //     component.set('v.docChecklistObj.RequiredDocCompletion__c', fields['RequiredDocCompletion__c']);
    //     component.set('v.docChecklistObj.ChecklistBy__c', fields['ChecklistBy__c']);
    //     component.set('v.docChecklistObj.ChecklistDateTime__c', fields['ChecklistDateTime__c']);
    //     component.set('v.docChecklistObj.CommitteeOwner__c', $A.get("$SObjectType.CurrentUser.Id"));
    //     component.set('v.docChecklistObj.CreditOwner__c', $A.get("$SObjectType.CurrentUser.Id"));
	// 	component.set('v.docChecklistObj.CreditOwnerSectionHead__c', component.get("v.TRCRHead"));

    //     this.saveDocCheck(component);
    // },

    // saveDocCheck: function (component) {
    //     var action = component.get('c.saveDocChecklist');
    //     action.setParams({
    //         "reqFormItem": component.get('v.docChecklistObj')
    //     });
    //     action.setCallback(this, function (response) {
    //         var state = response.getState();
    //         if (state === "SUCCESS") {
    //             this.showToast('Record saved successfully', true);
    //             component.set('v.showSpinner', false);
    //             this.toggleAlert(component);

    //         } else if (state === "ERROR") {
    //             var errors = response.getError();
    //             if (errors && errors[0] && errors[0].message) {
    //                 this.showToast(errors[0].message, false);
    //                 console.log("Error message: " + errors[0].message);
    //             }
    //             component.set('v.showSpinner', false);

    //         }
    //     });
    //     $A.enqueueAction(action);
    // },

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },
    /*
        getProfileName: function (component) {
            var action = component.get("c.getCurrentUserProfileName");
    
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var profileName = response.getReturnValue();
                    component.set('v.profile', profileName);
                    $A.get('e.force:refreshView').fire();
                    this.getDocChecklist(component);
                } else {
                    console.error('Error fetching profile name');
                }
            });
    
            $A.enqueueAction(action);
        },*/
    getBu: function (component) {
        var action = component.get("c.getBUInfo");
        action.setParams({
            "recordId": component.get('v.recordId')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var profileName = response.getReturnValue();
                component.set('v.profile', profileName.BusinessUnit__c);
                component.find("ChecklistBy__c").set("v.value", $A.get("$SObjectType.CurrentUser.Id"));

                var today = new Date();
                component.find("ChecklistDateTime__c").set("v.value", today.toISOString());
                //$A.get('e.force:refreshView').fire();
                this.getMetaDocList(component);
                this.getDocChecklist(component);
            } else {
                console.error('Error fetching profile name');
            }
        });

        $A.enqueueAction(action);
    },

    setRecordType: function (component, recordType) {
        if (recordType.includes('Customer')) {
            component.set('v.recordType', 'Customer');
        }
        if (recordType.includes('Supplier')) {
            component.set('v.recordType', 'Supplier');
        }
    },

    toggleAlert: function (component, event, helper) {
        var showAlert = !component.get("v.showAlert");
        component.set("v.showAlert", showAlert);

        if (showAlert) {
            // Display alert when showAlert is true
            component.set("v.alertMessage", "Saved changes! Are you want to request more document?");
        } else {
            // Hide alert when showAlert is false
            component.set("v.alertMessage", "");
        }
    },

    getMetaDocList: function (component) {
        var action = component.get('c.getMetaDocList');
        var recordId = component.get('v.recordId');
        action.setParams({
            "businessUnit": component.get('v.profile')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var metadataDocList = response.getReturnValue();
                console.log('Get meta data',metadataDocList)
                var requiredDocList = metadataDocList.filter((doc) => doc.IsRequired__c);

                component.set('v.requiredDocList',requiredDocList);
                component.set('v.metaDocList', metadataDocList);
                this.getDefaultDocChecklist(component)
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    getDefaultDocChecklist: function (component) {
        var recordId = component.get('v.recordId');
        var action = component.get('c.getDefaultDocChecklist');
        action.setParams({
            "recordId": recordId,
            "businessUnit": component.get('v.profile')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var currentDocList = response.getReturnValue();
                var metadataDocList = component.get('v.metaDocList');
                var transResultMap = {'Passed': 'Pass', 'Waived': 'Waive', 'Not Passed': 'Not Pass'};
                var mapKeyResult = {}
                currentDocList.forEach((doc) => {
                    mapKeyResult[doc.ExternalKey__c] = transResultMap[doc.Result__c];
                })
                
                var selectedDocObj = {};
                metadataDocList.forEach((doc) => {
                    var key = doc.DeveloperName+recordId;
                    var defaultResult = (key in mapKeyResult) ? mapKeyResult[key] : null;
                    selectedDocObj[key] = {
                        name: doc.DocumentName__c,
                        result: defaultResult,
                        required: doc.IsRequired__c
                    }
                    doc['DefaultResult'] = defaultResult;
                })
                component.set('v.metaDocList', metadataDocList);
                component.set('v.selectedDocObj',selectedDocObj);
                this.checkRequiredDocCompletion(component)
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    checkRequiredDocCompletion : function (component) {
        var recordId = component.get('v.recordId');
        var requiredDocList = component.get('v.requiredDocList');
        var selectedDocObj = component.get('v.selectedDocObj');
        var checkResult = null
        var hasDocSelected = false;
        Object.keys(selectedDocObj).some(key => {
            if(key in selectedDocObj && selectedDocObj[key].result) {
                hasDocSelected = true;
                return;
            }
        });
        if(Object.keys(selectedDocObj).length > 0 && hasDocSelected) {
            checkResult = 'Pass'
            requiredDocList.some(requiredDoc => {
                var key = requiredDoc.DeveloperName+recordId;
                if(key in selectedDocObj) {
                    if(!['Pass','Waive'].includes(selectedDocObj[key].result) || !selectedDocObj[key].result) { // result not pass
                        checkResult = 'Not Pass';
                        return;
                    }
                } else { // not select the required
                    checkResult = 'Not Pass'
                    return;
                }
            });
        }
        component.find("RequiredDocCompletion__c").set("v.value",checkResult);
    },

    setDocChecklist: function (component, fields) {
        component.set('v.docChecklistObj.Id', component.get('v.recordId'));
        // component.set('v.docChecklistObj.HasCOI__c', fields['HasCOI__c']);
        // component.set('v.docChecklistObj.HasMOA__c', fields['HasMOA__c']);
        // component.set('v.docChecklistObj.hasAuditedFinalcial__c', fields['hasAuditedFinalcial__c']);
        // component.set('v.docChecklistObj.HasShareHolders__c', fields['HasShareHolders__c']);
        // component.set('v.docChecklistObj.HasCertofVATRegistration__c', fields['HasCertofVATRegistration__c']);
        // component.set('v.docChecklistObj.HasRegistrationIssue__c', fields['HasRegistrationIssue__c']);
        // component.set('v.docChecklistObj.HasPowerofAttorney__c', fields['HasPowerofAttorney__c']);
        component.set('v.docChecklistObj.HasOtherDocument__c', fields['HasOtherDocument__c']);
        component.set('v.docChecklistObj.ListOtherDocument__c', fields['ListOtherDocument__c']);
        component.set('v.docChecklistObj.RequiredDocCompletion__c', fields['RequiredDocCompletion__c']);
        component.set('v.docChecklistObj.ChecklistBy__c', fields['ChecklistBy__c']);
        component.set('v.docChecklistObj.ChecklistDateTime__c', fields['ChecklistDateTime__c']);
        component.set('v.docChecklistObj.CommitteeOwner__c', $A.get("$SObjectType.CurrentUser.Id"));
        component.set('v.docChecklistObj.CreditOwner__c', $A.get("$SObjectType.CurrentUser.Id"));
		component.set('v.docChecklistObj.CreditOwnerSectionHead__c', component.get("v.TRCRHead"));
        this.saveDocCheck(component);
    },

    saveDocCheck: function (component) {
        var selectedDocObj = component.get('v.selectedDocObj');
        var docItemChecklist = this.transSelectedDocFormat(component,selectedDocObj)
        var action = component.get('c.saveDocChecklist');
        action.setParams({
            "reqFormItem": component.get('v.docChecklistObj'),
            "docItemChecklist": docItemChecklist,
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast('Record saved successfully', true);
                component.set('v.showSpinner', false);
                this.toggleAlert(component);

            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
                component.set('v.showSpinner', false);

            }
        });
        $A.enqueueAction(action);
    },

    transSelectedDocFormat : function(component,selectedDocObj) {
        var recordId = component.get('v.recordId');
        var bu = component.get('v.profile');
        var result = [];
        var transResultMap = {'Pass': 'Passed', 'Waive': 'Waived', 'Not Pass': 'Not Passed'};
        Object.keys(selectedDocObj).forEach((key) => {
            var docObj = selectedDocObj[key];
            var docResult = docObj.result in transResultMap ? transResultMap[docObj.result] : null;
            var CTRDocItem = {
                DocumentName__c: docObj.name,
                CTRRequestFormItem__c: recordId,
                ExternalKey__c: key,
                Result__c: docResult, //format of CTRDocumentItem
                BusinessUnit__c: bu,
                IsRequired__c: docObj.required
            }
            result.push(CTRDocItem);
        })
        return result;
    }
})