// ({
//     submitFiles : function(component, event, helper) {
//         // Retrieve file input
//         var fileInput = component.find("fileInput").getElement();
//         var file = fileInput.files[0];

//         // Additional data you want to send to Apex
//         var title = component.get("v.title");

//         // Call an Apex method to handle file submission
//         var action = component.get("c.processFiles");
//         action.setParams({
//             "file": file,
//             "title": title
//         });

//         action.setCallback(this, function(response) {
//             var state = response.getState();
//             if (state === "SUCCESS") {
//                 // File submission was successful
//                 // You can handle the response from Apex if needed
//             } else {
//                 // Handle errors
//                 console.error('Error: ' + response.getError()[0].message);
//             }
//         });

//         $A.enqueueAction(action);
//     }
// })

({

    handleUploadFinished: function(component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
    
        // Store the list of files in the component attribute
        component.set("v.uploadedFiles", uploadedFiles);
    
        // Update the file list based on the uploaded files
        this.handleFileChange(component);
    },
    
    handleFileChange: function(component, event, helper) {
        console.log('handleFileChange function');
    
        // Get the list of uploaded files from v.uploadedFiles
        var uploadedFiles = component.get("v.uploadedFiles");
    
        // Create or update the v.fileList attribute
        var fileList = [];
        for (var i = 0; i < uploadedFiles.length; i++) {
            fileList.push({ Title: uploadedFiles[i].name, Content: uploadedFiles[i] });
        }
    
        component.set("v.fileList", fileList);
        console.log('fileList: ', component.get("v.fileList"));
    },
    

    submitFiles : function(component, event, helper) {
        // Retrieve the list of uploaded files
        var uploadedFiles = component.get("v.uploadedFiles");
        console.log('--uploadedFiles--'+uploadedFiles);

        // Additional data you want to send to Apex
        var title = component.get("v.title");
        console.log('--title--'+title);

        // Call an Apex method to handle file submission
        var action = component.get("c.processFiles");
        action.setParams({
            "files": uploadedFiles,
            "title": title
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // File submission was successful

            } else {
                // Handle errors
                console.error('Error: ' + response.getError()[0].message);
            }
        });

        $A.enqueueAction(action);
    },

    //-------------------

    // handleFileChange: function(component, event, helper) {
    //     consdole.log('handleFileChange function');
    //     var fileInput = component.find("files").getElement();
    //     var files = fileInput.files;

    //     // Loop through the selected files and add them to the list
    //     var fileList = component.get("v.fileList");
    //     for (var i = 0; i < files.length; i++) {
    //         fileList.push({ Title: '', Content: files[i] });
    //     }

    //     component.set("v.fileList", fileList);
    //     console.log('fileList: ',component.get("v.fileList"));
    // },

    // uploadFiles: function(component, event, helper) {
    //     consdole.log('uploadFiles function');
    //     // var fileList = component.get("v.fileList");

    //     // // Call the Apex controller to handle file upload
    //     // var action = component.get("c.uploadFiles");
    //     // action.setParams({ fileList: fileList });

    //     // action.setCallback(this, function(response) {
    //     //     // Handle response from the Apex controller
    //     //     var state = response.getState();
    //     //     if (state === "SUCCESS") {
    //     //         // Do something with the success response
    //     //         console.log('success');
    //     //     } else {
    //     //         // Handle error
    //     //         console.error("Error in calling Apex controller: " + state);
    //     //     }
    //     // });

    //     // $A.enqueueAction(action);
    // }
})