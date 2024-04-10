({
	doInit : function(component, event, helper) {
		helper.getRecordTypes(component);
    },
    handleRecordUpdated: function (component, event, helper) {
		//alert(component.get('v.leadRecordId'));
        //alert(component.get('v.record')); 
        
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
    
     updateFileList: function (component, event, helper) {
         //alert('updateFileList');
        var action = component.get('c.updateListFileNameFroLead');
        action.setParams({
            "recordId": component.get('v.recordId'),
            "uploadedFile": component.get('v.uploadedFile')
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //alert('updateFileList s');
                helper.getListFile(component);
            } else if (state === "ERROR") {
                //alert('updateFileList e');
                var errors = response.getError();
                if (errors && errors[0] && errors[0].message) {
                    this.showToast(errors[0].message, false);
                    console.log("Error message: " + errors[0].message);
                }
            }
            component.set('v.isUploadSuccess', false);
        });
        $A.enqueueAction(action);
    },onClickSave: function (component, event, helper) {
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
		/*
        if (fileList && fileList.length > 0) {
            component.set('v.isUpload', true);
        }*/
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
        
        //helper.saveEmail(component);
        // helper.closeModal(component);
    },handlePreview: function (component, event, helper) {
        //alert(JSON.stringify(component.get('v.emailInfo')));
        //alert(component.get('v.attachments'));
        console.log('v. Attachment ' +component.get('v.attachments'));
        var fileNameList = component.get('v.fileList');
        var PreviewFileList = component.get('v.attachments');
        component.set('v.PreviewFileList', []);
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
    		newPreviewFileList.push(fileObject);
        }
        console.log('new Attachment ' + JSON.stringify(newPreviewFileList ));
        component.set('v.PreviewFileList', newPreviewFileList);
		
        component.set('v.isPreview', false);       
        component.set('v.isPreview', true);
        
        
    },
    handleComponentEvent : function(component, event, helper) {
                console.log('isUploadDone--document--');
                
                //var valueFromUploadFileAura = event.getParam("message");
                
                //component.set("v.isUploadDone", valueFromUploadFileAura);
                
                helper.saveEmail(component);
            }
    
    
})