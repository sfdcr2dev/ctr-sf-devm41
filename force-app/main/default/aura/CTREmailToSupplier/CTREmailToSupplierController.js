({
    doInit : function(component, event, helper) {
        helper.getRecordTypes(component);
    },
    
    handleToggleSection : function(component, event, helper) {
        var sectionAuraId = event.currentTarget.getAttribute("data-auraid");
        console.log('[handleToggleSection] selectionAuraId -----', sectionAuraId);
        
        // get section Div element using aura:id 
        var sectionDiv = component.find(sectionAuraId).getElement();
        console.log('[handleToggleSection] sectionDiv -----', sectionDiv);
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open');
        console.log('[handleToggleSection] sectionState -----', sectionState);
        // -1 open/close section
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section'); // slds-is-close 
        }
    },
    
    closeModal : function(component, event, helper) {
        helper.closeModal(component);
    },
    
    onClickSave: function (component, event, helper) {
        component.set('v.showSpinner', true);
        
        var fileList = component.get('v.fileList');
        var fileToDelList = component.get('v.fileToDelList');
        
        component.set('v.isSubmit', false);
        
        if (fileList && fileList.length > 0) {
            component.set('v.isUpload', true);
        }
        if (fileToDelList && fileToDelList.length > 0) {
            component.set('v.isDelFile', true);
        }
        
        helper.saveEmail(component);
        // helper.closeModal(component);
    },
    
    onClickSubmit: function (component, event, helper) {
        component.set('v.showSpinner', true);
        var fileList = component.get('v.fileList');
        var fileToDelList = component.get('v.fileToDelList');
        
        component.set('v.isSubmit', true);
        
        
        if (fileToDelList && fileToDelList.length > 0) {
            component.set('v.isDelFile', true);
        }
        if (fileList && fileList.length > 0) {
            component.set('v.isUpload', true);
        }
        else
        {
            helper.saveEmail(component);
        }
        helper.uploadFileToSharePoint(component);
        /*
        setTimeout(() => {
            helper.saveEmail(component);
        }, 2500);*/
            
            // helper.closeModal(component);
        },
            updateFileList: function (component, event, helper) {
                console.log('uploadedFile '+component.get('v.uploadedFile'));
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
                console.log('uploadedFile '+component.get('v.uploadedFile'));
                console.log('fileList '+component.get('v.fileList'));
                console.log('showLoadingSpinner '+component.get('v.showLoadingSpinner'));
                console.log('isUpload '+component.get('v.isUpload'));
                console.log('isFetchAttachments '+component.get('v.isFetchAttachments'));
                console.log('attachments ' + JSON.stringify(component.get('v.attachments')));
                component.set('v.PreviewFileList', []);
                var fileNameList = component.get('v.fileList');
                var PreviewFileList = component.get('v.attachments');
                if(PreviewFileList == null){
                    PreviewFileList = [];
                }
                var newPreviewFileList = [...PreviewFileList];
                console.log('old Attachment ' +PreviewFileList );
                for (let i = 0; i < fileNameList.length; i++) {
                    var fileObject = {
                        Id: '',         // You may populate these properties as needed
                        Title: fileNameList[i]
                    };
                    
                    console.log(fileObject);
                    console.log('attachments before push ' + JSON.stringify(component.get('v.attachments')));
                    newPreviewFileList.push(fileObject);
                    console.log('attachments push ' + JSON.stringify(component.get('v.attachments')));
                }
                console.log('new Attachment ' + JSON.stringify(newPreviewFileList ));
                // {"Id":"0691m000003NnLGAA0","Title":"pexels-photo-1133957.webp"}
                
                component.set('v.PreviewFileList', newPreviewFileList);
                component.set('v.emailInfo.EmailCC__c', component.get('v.selectedEmailCC'));
                component.set('v.isPreview', false);       
                component.set('v.isPreview', true);  
            },
            handleComponentEvent : function(component, event, helper) {
                console.log('isUploadDone----');
                
                //var valueFromUploadFileAura = event.getParam("message");
                
                //component.set("v.isUploadDone", valueFromUploadFileAura);
                
                helper.saveEmail(component);
            },
    handleUploadFinished: function (cmp, event) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        alert("Files uploaded : " + uploadedFiles.length);

        // Get the file name
        uploadedFiles.forEach(file => console.log(file.name));
    }
        })