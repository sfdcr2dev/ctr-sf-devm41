({
    doInit: function (component, event, helper) {
        console.log('emailInfo--------' + JSON.stringify(component.get('v.emailInfo')));

        //helper.getListFile(component)
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

    showSpinner: function (component, event, helper) {
        setTimeout(function () {
            component.set('v.showSpinner', false);
        }, 2000);
    },

    onClickBack: function (component, event, helper) {
        component.set("v.isReqDoc", false);
    },

    onClickCancel: function (component, event, helper) {
        component.set('v.fileList', []);
        component.set('v.fileToDelList', []);
        component.set('v.isFetchAttachments', true);
        helper.closeModal(component);
    },

    onClickSave: function (component, event, helper) {
        component.set('v.showSpinner', true);

        component.set('v.isSubmit', false);

        // Option 1
        // var fileList = component.get('v.fileList');
        // var fileToDelList = component.get('v.fileToDelList');

        // console.log('fileToDelList: ' + fileToDelList);
        // if (fileList && fileList.length > 0) {
        //     //component.set('v.isUpload', true);
        // }
        // if (fileToDelList && fileToDelList.length > 0) {
        //     component.set('v.isDelFile', true);
        // }

        // Option 2
        // const CTRFileUploader = component.find('CTRFileUploader');
        // CTRFileUploader.onSave().then((r) => {
        //     console.log('saved:' + JSON.stringify(component.get("v.jsonFileList")));
        // });
        // helper.saveReqDoc(component);

        component.find("CTRFileUpload").deletePendingAttachments()
            .then($A.getCallback(function() {
                component.set( "v.reqDocObj.CustomerAttachment__c", JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                component.set( "v.uploadedFile", JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                helper.saveReqDoc(component);
            }));
    },

    onClickSubmit: function (component, event, helper) {
        component.set('v.showSpinner', true);
		component.set('v.isSubmit', true);
        // For Option 1, 2, 3
        // var fileList = component.get('v.fileList');
        // var fileToDelList = component.get('v.fileToDelList');

        // component.set('v.isSubmit', true);
        // /*
        //         if (fileList && fileList.length > 0) {
        //             component.set('v.isUpload', true);
        //         }*/
        // if (fileToDelList && fileToDelList.length > 0) {
        //     component.set('v.isDelFile', true);
        // }

        // Option 1
        /*
        if (fileList && fileList.length > 0) {
            component.set('v.isUpload', true);
        }
        else
        {
            helper.saveReqDoc(component);
        }*/

        // Option 2
        //helper.saveReqDoc(component);

        // Option 3
        // helper.saveReqDoc(component);
        // helper.uploadFileToSharePoint(component);

        component.find("CTRFileUpload").deletePendingAttachments()
            .then($A.getCallback(function() {
                component.set( "v.reqDocObj.CustomerAttachment__c", JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                component.set( "v.uploadedFile", JSON.stringify(component.find("CTRFileUpload").getMergedAttachments()));
                helper.saveReqDoc(component);
                //helper.uploadFileToSharePoint(component);
            }));
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
        //component.set('v.emailInfo.EmailCC__c', component.get('v.selectedEmailCC'));
        component.set('v.PreviewFileList', []);
        console.log('null PreviewFileList ' + component.get('v.PreviewFileList'));
        var fileNameList = component.get('v.fileList');
        var PreviewFileList = component.get('v.attachments');
        component.set('v.PreviewFileList', []);
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

            console.log('new fileObject ' + fileObject);
            newPreviewFileList.push(fileObject);
        }
        console.log('new Attachment ' + JSON.stringify(newPreviewFileList));
        component.set('v.PreviewFileList', component.find("CTRFileUpload").getMergedAttachments());
        // component.set('v.PreviewFileList', newPreviewFileList);

        component.set('v.isPreview', false);
        component.set('v.isPreview', true);
        console.log("isPreview 1-" + component.get('v.isPreview'));
        /*
        if(component.get('v.isPreview')){
            component.set('v.isPreview', false);  
            console.log("isPreview 2-" + component.get('v.isPreview'));
        }else{
            component.set('v.isPreview', true);  
            console.log("isPreview 3-" + component.get('v.isPreview'));
        }*/
    }
    ,
    handleComponentEvent: function (component, event, helper) {
        console.log('isUploadDone--document--');

        //var valueFromUploadFileAura = event.getParam("message");

        //component.set("v.isUploadDone", valueFromUploadFileAura);

        helper.saveReqDoc(component);
    }
    ,
    recordUpdate: function (component, event, helper) {
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
    // handleFileListChange: function (component, event, helper) {
    //     try {
    //         component.find("attachments").set("v.value", JSON.stringify(component.get("v.jsonFileList")));
    //         component.set("v.reqDocObj.CustomerAttachment__c", JSON.stringify(component.get("v.jsonFileList")));
    //         component.find("requestItemLoader").saveRecord($A.getCallback(function (saveResult) {
    //             console.log(saveResult);
    //         }));
    //     } catch (ex) {
    //         console.error(ex)
    //     }
    // },
    // handleFileToDeleteChange: function (component, event, helper) {
    //     let fileToDelList = component.get('v.fileToDelList') || []
    //     if (fileToDelList.length) {
    //         let oldAttachments = component.get('v.uploadedFile') ? JSON.parse(component.get('v.uploadedFile')) : []

    //         let newAttachments = oldAttachments.filter((item) => {
    //             return fileToDelList.indexOf(item.Id) < 0
    //         })
    //         //debugger;
    //         component.set('v.uploadedFile', JSON.stringify(newAttachments))
    //         component.set("v.reqDocObj.CustomerAttachment__c", JSON.stringify(newAttachments))
    //     }
    // }
})