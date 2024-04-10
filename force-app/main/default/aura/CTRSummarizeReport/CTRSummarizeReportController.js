({
    doInit: function (component, event, helper) {
        console.log('doinit');
        helper.getProfileName(component);

        var userQueryCond = '(NOT Email LIKE \'%.invalid%\') AND isActive = true';
        component.set('v.userQueryCond', userQueryCond);

        helper.getListFile(component)
    },

    handleToggleSection: function (component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute("data-auraid");
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);

        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if (sectionState == -1) {
            sectionDiv.setAttribute('class', 'slds-section slds-is-open');
        } else {
            sectionDiv.setAttribute('class', 'slds-section'); // slds-is-close 
        }
    },

    closeModal: function (component, event, helper) {
        helper.closeModal(component);
    },

    onClickSave: function (component, event, helper) {
        component.set('v.showSpinner', true);


        component.set('v.isSubmit', false);

        // Option 1
        // var fileList = component.get('v.fileList');
        // var fileToDelList = component.get('v.fileToDelList');
        // if (fileList && fileList.length > 0) {
        //     // component.set('v.isUpload', true);
        // }
        // if (fileToDelList && fileToDelList.length > 0) {
        //     component.set('v.isDelFile', true);
        // }

        // Option 2
        // const CTRFileUploader = component.find('CTRFileUploader');
        // CTRFileUploader.onSave().then((r) => {
        //     console.log('saved:' + JSON.stringify(component.get("v.jsonFileList")));
        // });
        // component.set('v.sumRepObj.Approval_Step__c', 'Summary Report');

        // helper.saveSumRep(component);

        component.find("CTRFileUpload").deletePendingAttachments()
            .then($A.getCallback(function () {
                component.set("v.sumRepObj.SummarizeReportAttachment__c",
                    JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));

                return helper.saveSumRep(component);
            }))
            .then($A.getCallback(function() {
                setTimeout($A.getCallback(function() {
                    window.location.reload();
                }), 3000);
            }));

        // helper.closeModal(component);
    },

    onClickSubmit: function (component, event, helper) {
        component.set('v.showSpinner', true);

        // Option 1
        /*
        if (fileList && fileList.length > 0) {
            //console.log('v.isUploadDoneSumary ' + component.get('v.isUploadDoneSumary'));
            //component.set('v.isUpload', true);
        }
        else
        {
            helper.saveSumRep(component);
        }*/

        // var fileList = component.get('v.fileList');
        // var fileToDelList = component.get('v.fileToDelList');

        // component.set('v.isSubmit', true);

        // Option 2
        // /*
        // if (fileList && fileList.length > 0) {
        //     component.set('v.isUpload', true);
        // }*/
        // if (fileToDelList && fileToDelList.length > 0) {
        //     component.set('v.isDelFile', true);
        // }
        // component.set('v.sumRepObj.Approval_Step__c', 'Inform Counterparty');
        // component.set('v.sumRepObj.NotifyCustomAction__c', 'Submit Summary Report');
        // helper.saveSumRep(component);
        // helper.uploadFileToSharePoint(component);

        component.find("CTRFileUpload").deletePendingAttachments()
            .then($A.getCallback(function () {
                component.set(
                    "v.sumRepObj.SummarizeReportAttachment__c",
                    JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));

                component.set('v.isSubmit', true);
                return helper.saveSumRep(component);
            }))
            .then($A.getCallback(function () {
                helper.uploadFileToSharePoint(component);

                setTimeout($A.getCallback(function() {
                    window.location.reload();
                }), 3000);
            }));

        // helper.closeModal(component);
    },

    updateFileList: function (component, event, helper) {
        var action = component.get('c.updateListFileName');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "uploadedFile": component.get('v.uploadedFile')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                helper.getListFile(component);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
            component.set('v.isUploadSuccess', false);
        });
        $A.enqueueAction(action);
    },
    handlePreview: function (component, event, helper) {
        console.log('email ' + component.get('v.selectedEmailCC'));
        console.log('v.Attachment ' + component.get('v.attachments'));
        component.set('v.PreviewFileList', []);
        var fileNameList = component.get('v.fileList');
        var PreviewFileList = component.get('v.attachments');
        if (PreviewFileList == null) {
            PreviewFileList = [];
        }
        var newPreviewFileList = [...PreviewFileList];
        console.log('old Attachment ' + PreviewFileList);
        for (let i = 0; i < fileNameList.length; i++) {
            var fileObject = {
                Id: '',         // You may populate these properties as needed
                Title: fileNameList[i]
            };

            console.log(fileObject);
            newPreviewFileList.push(fileObject);
        }
        console.log('new Attachment ' + JSON.stringify(newPreviewFileList));
        component.set('v.PreviewFileList', component.find("CTRFileUpload").getMergedAttachments());

        component.set('v.emailInfo.EmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.isPreview', false);
        component.set('v.isPreview', true);
        /*
        if(component.get('v.isPreview')){
              component.set('v.isPreview', false);           
        }else{
              component.set('v.isPreview', true);   
        }*/
        //component.set('v.isPreview', true);  
    },
    handleComponentEvent: function (component, event, helper) {
        console.log('isUploadDone--sum--');

        //var valueFromUploadFileAura = event.getParam("message");

        //component.set("v.isUploadDone", valueFromUploadFileAura);
        /*
        if(component.get('v.isUploadDone') == true)
        {
            console.log('isUploadDone--true--');
           helper.saveSumRep(component); 
        }*/
        helper.saveSumRep(component);
        //component.set('v.isUploadDone', false);
    },
    // handleFileListChange: function (component, event, helper) {
    //     try {
    //         component.find("attachments").set("v.value", JSON.stringify(component.get("v.jsonFileList")));
    //         component.set("v.sumRepObj.SummarizeReportAttachment__c", JSON.stringify(component.get("v.jsonFileList")));
    //         component.find("requestItemLoader").saveRecord($A.getCallback(function (saveResult) {
    //             console.log(saveResult);
    //         }));
    //     } catch (ex) {
    //         console.error(ex)
    //     }
    // },
    recordUpdate: function(component, event, helper) {
        // let requestItemRecord = component.get("v.requestItemRecord")
        // let oldAttachments = JSON.parse(requestItemRecord.SummarizeReportAttachment__c) || [];
        
        // let attachments = oldAttachments.filter((item) => item.IsSaved);
        // component.set("v.attachments", attachments);
        
        // // let fileToDelList = oldAttachments.filter((item) => !item.IsSaved);
        // // let idFileToDelList = fileToDelList.map((item) => item.Id);
        // // debugger;
        // // component.set("v.fileToDelList", idFileToDelList);
        // // component.set("v.isDelFile", true);
    },
    // handleFileToDeleteChange: function(component, event, helper) {
    //     let fileToDelList = component.get('v.fileToDelList') || []
    //     if (fileToDelList.length) {
    //         let oldAttachments = component.get('v.uploadedFile') ? JSON.parse(component.get('v.uploadedFile')) : []

    //         let newAttachments = oldAttachments.filter((item) => {
    //             return fileToDelList.indexOf(item.Id) < 0
    //         })
    //         // debugger;
    //         component.set('v.uploadedFile', JSON.stringify(newAttachments))
    //         component.set("v.sumRepObj.SummarizeReportAttachment__c", JSON.stringify(newAttachments))
    //     }
    // },
})