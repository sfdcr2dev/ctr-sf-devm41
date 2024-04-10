({
    doInit: function (component, event, helper) {
        //helper.checkWriteAccess(component);
    },

    handleUploadFinished: function (component, event, helper) {
        // https://sfdclesson.com/2019/06/23/%E2%9A%A1-lightning-file-upload-with-a-title-using-lightningfileupload/
        var uploadedFiles = event.getParam('files');
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        fileName = fileName.substring(0, fileName.lastIndexOf('.'));
        console.log(uploadedFiles[0], fileName);

        component.set('v.originalFileName', fileName);

        // set the attribute to the document we want to do stuff with
        // so we can get it and use the Id in other fucntions
        component.set('v.currentUploadedDocumentId', documentId);
        
        helper.updateDocument(component, documentId, fileName); //** */
    },
});