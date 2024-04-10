({
    doInit: function (component, event, helper) {

        var attachText = document.getElementsByClassName("slds-form-element__help");

        attachText.innerHTML="The file number exceeds the maximum limit (at 10 files)";
        var getCallPage = component.get("v.attachments");


        var getCallPage = component.get("v.callPage");
        if(getCallPage == "CTRCommitteeSelection") {
        	helper.fetchAttachmentsSpecial(component);
        } else {
        	//helper.fetchAttachments(component);
        }

        //component.set("v.attachments", [{"Id":"0691m000003O3RKAA0","Title":"Credit Score.postman_collection - Copy (2).json","isUnsaved":true},{"Id":"0691m000003O3RUAA0","Title":"Credit Score.postman_collection - Copy.json","isUnsaved":true},{"Id":"0691m000003O3ReAAK","Title":"Credit Score.postman_collection.json","isUnsaved":true}]);
    	console.log('ff');
        console.log('FileList');
        console.log(component.get("v.newFileList"));
        console.log('attachments');
        console.log(component.get("v.attachments"));
        console.log('jsonFileList');
        console.log(component.get("v.jsonFileList"));
        console.log('uploadedFile');
        console.log(component.get("v.uploadedFile"));
    },


    handleFilesChange: function (component, event, helper) {
        console.log('handleFilesChange----1');
        // var newFileList = component.get("v.newFileList") || [];

        var uploadedFiles = event.getParam("files");
        var newFiles = event.getParam("files");//event.getSource().get("v.files");
        let documentIds = newFiles.map((item) => { return item.documentId });

        console.log('newfiles');
        console.log(newFiles);
        // console.log(newFileList);
        console.log('handleFilesChange----2');
        // for (var i = 0; i < newFiles.length; i++) {
        //  	newFileList.push(newFiles[i].name);
        // }
        console.log('recordId:');
        console.log(component.get("v.recordId"));
        console.log('handleFilesChange----3');

        const jsonFileList = newFiles.map((item) => {
            return {
                Id: item.documentId,
                Title: item.name,
                IsSaved: false,
            }
        });
        console.log('jsonlist');
        console.log(jsonFileList);
		console.log('checkSpec');

        Promise.all([helper.checkConditions(component,event, helper, uploadedFiles)]).then((errIds)=>{

            if(errIds && errIds.length > 0) {
                var action = component.get("c.addToDeleteList");
                action.setParams({ "attachmentIds": errIds });

                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        console.log('delete successful')
                    } else {
                        console.error("Failed to delete attachments");
                    }
                });
                $A.enqueueAction(action);
            }
            helper.updateUploadedFile(component, helper, false);
            // if(checkSpecialUploadPass[0] == false) {
            //     var newFileList = component.get("v.newFileList") || [];

            //     console.log('checkSpec1');
            //         console.log(checkSpecialUploadPass);
            //         //let newFileList = component.get("v.newFileList");

            //         if(jsonFileList) {
            //             jsonFileList.forEach((item) => {
            //                 newFileList.push(item);
            //             });
            //             component.set("v.newFileList", newFileList);
            //         }
            //         // component.set("v.newFileList", uploadedFiles );
            //         // TODO:
            //         // component.set("v.jsonFileList", jsonFileList);
            //         helper.updateUploadedFile(component, helper, false);


            //         // console.log('handleFilesChange----'+JSON.stringify(component.get('v.newFileList')));
            //         // console.log('handleFilesChange----jsonFileList'+component.get('v.jsonFileList'));


            //         // component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(jsonFileList))
            //         // console.log('requestFormObj==>',JSON.stringify(component.get("v.requestFormObj")))
            //         // component.set('v.uploadedFile', JSON.stringify(jsonFileList))

            //         // Get the list of uploaded files
            //         //var uploadedFiles = event.getParam("files");
            //         //alert("Files uploaded : " + uploadedFiles.length);

            //         // Get the file name
            //         uploadedFiles.forEach(file => console.log('file-----'+JSON.stringify(file)));
            //     } else {
            //         //alert('False');
            //     console.log('checkSpec2');
            //         console.log(checkSpecialUploadPass);
            //         console.log('Get error:');
            //         console.log(component.get('v.errList'));

            //                     //var fileNameToRemove = newFiles[0].name;
            //                     var attachIdToRemove = '';
        	// 					var filesToRemove = component.get('v.errIds');
        	// 					var newFileList = component.get("v.newFileList");
			// 			        filesToRemove.forEach(function(errId){
            //                         attachIdToRemove = errId;
        	// 						console.log('attachIdToRemove---'+attachIdToRemove);
        	// 						newFileList = newFileList.filter(function (file) {
            // 							// return file !== fileNameToRemove;
            //                             return file.Id !== attachIdToRemove;
        	// 						});
        	// 					});
            //                     component.set("v.newFileList", newFileList);
        	// 					console.log("v.newFileList ====");
        	// 					console.log(newFileList);
        	// 					console.log("v.jsonFileList ====");
        	// 					console.log(jsonFileList);

            //         //component.set("v.fileToDelList",newFiles[0].Id);
            //         //component.set("v.isDelFile",true);
            //         //this.addToDeleteList(component, event, helper);
            //         //this.removeFile(component, event, helper);

            //         //component.set("v.fileToDelList",newFiles[0].documentId);
            //         component.set("v.fileToDelList",component.get('v.errIds'));
            //         var action = component.get("c.addToDeleteList");
            //         //action.setParams({ "attachmentIds": fileToDelList });
            //         action.setCallback(this, function (response) {
            //                 var state = response.getState();
            //                 if (state === "SUCCESS") {
            //                     console.log('delete successful')
            //                 } else {
            //                     console.error("Failed to delete attachments");
            //                 }
            //             });
            //          $A.enqueueAction(action);
            //     }
        }).catch((error)=>{
            console.error('checkSpecialConditions error',error)
        })
    },

    handleFilesChangeTemp: function (component, event, helper) {
        console.log('handleFilesChange----1');
			// var newFileList = component.get("v.newFileList") || [];

			var uploadedFiles = event.getParam("files");
			var newFiles = event.getParam("files");//event.getSource().get("v.files");
        console.log('newfiles');
        console.log(newFiles);
        // console.log(newFileList);
			console.log('handleFilesChange----2');
			// for (var i = 0; i < newFiles.length; i++) {
			//  	newFileList.push(newFiles[i].name);
			// }
			console.log('recordId:');
			console.log(component.get("v.recordId"));
			console.log('handleFilesChange----3');
			const jsonFileList = newFiles.map((item) => {
				return {
					Id: item.documentId,
					Title: item.name,
					IsSaved: false,
				}
			})
            console.log('jsonlist');
        console.log(jsonFileList);
		console.log('checkSpec');

        Promise.all([helper.checkSpecialConditions(component,event,"",false)]).then((checkSpecialUploadPass)=>{
            if(checkSpecialUploadPass[0] == false) {
                var newFileList = component.get("v.newFileList") || [];

                console.log('checkSpec1');
                    console.log(checkSpecialUploadPass);
                    //let newFileList = component.get("v.newFileList");

                    if(jsonFileList) {
                        jsonFileList.forEach((item) => {
                            newFileList.push(item);
                        });
                        component.set("v.newFileList", newFileList);
                    }
                    // component.set("v.newFileList", uploadedFiles );
                    // TODO:
                    // component.set("v.jsonFileList", jsonFileList);
                    helper.updateUploadedFile(component, helper, false);


                    // console.log('handleFilesChange----'+JSON.stringify(component.get('v.newFileList')));
                    // console.log('handleFilesChange----jsonFileList'+component.get('v.jsonFileList'));


                    // component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(jsonFileList))
                    // console.log('requestFormObj==>',JSON.stringify(component.get("v.requestFormObj")))
                    // component.set('v.uploadedFile', JSON.stringify(jsonFileList))

                    // Get the list of uploaded files
                    //var uploadedFiles = event.getParam("files");
                    //alert("Files uploaded : " + uploadedFiles.length);

                    // Get the file name
                    uploadedFiles.forEach(file => console.log('file-----'+JSON.stringify(file)));
                } else {
                    //alert('False');
                console.log('checkSpec2');
                    console.log(checkSpecialUploadPass);
                    console.log('Get error:');
                    console.log(component.get('v.errList'));

                                //var fileNameToRemove = newFiles[0].name;
                                var attachIdToRemove = '';
        						var filesToRemove = component.get('v.errIds');
        						var newFileList = component.get("v.newFileList");
						        filesToRemove.forEach(function(errId){
                                    attachIdToRemove = errId;
        							console.log('attachIdToRemove---'+attachIdToRemove);
        							newFileList = newFileList.filter(function (file) {
            							// return file !== fileNameToRemove;
                                        return file.Id !== attachIdToRemove;
        							});
        						});
                                component.set("v.newFileList", newFileList);
        						console.log("v.newFileList ====");
        						console.log(newFileList);
        						console.log("v.jsonFileList ====");
        						console.log(jsonFileList);

                    //component.set("v.fileToDelList",newFiles[0].Id);
                    //component.set("v.isDelFile",true);
                    //this.addToDeleteList(component, event, helper);
                    //this.removeFile(component, event, helper);

                    //component.set("v.fileToDelList",newFiles[0].documentId);
                    component.set("v.fileToDelList",component.get('v.errIds'));
                    var action = component.get("c.addToDeleteList");
                    //action.setParams({ "attachmentIds": fileToDelList });
                    action.setCallback(this, function (response) {
                            var state = response.getState();
                            if (state === "SUCCESS") {
                                console.log('delete successful')
                            } else {
                                console.error("Failed to delete attachments");
                            }
                        });
                     $A.enqueueAction(action);
                }
        }).catch((error)=>{
            console.error('checkSpecialConditions error',error)
        })

		// var checkSpecialUploadPass = helper.checkSpecialConditions(component,event,"",false);

		// if(checkSpecialUploadPass == false) {
		// console.log('checkSpec1');
        //     console.log(checkSpecialUploadPass);
		// 	component.set("v.newFileList", newFileList );
		// 	component.set("v.jsonFileList", jsonFileList);
		// 	// console.log('handleFilesChange----'+JSON.stringify(component.get('v.newFileList')));
		// 	// console.log('handleFilesChange----jsonFileList'+component.get('v.jsonFileList'));


		// 	// component.set("v.requestFormObj.CommitteeAttachment__c", JSON.stringify(jsonFileList))
		// 	// console.log('requestFormObj==>',JSON.stringify(component.get("v.requestFormObj")))
		// 	// component.set('v.uploadedFile', JSON.stringify(jsonFileList))

		// 	// Get the list of uploaded files
		// 	//var uploadedFiles = event.getParam("files");
		// 	//alert("Files uploaded : " + uploadedFiles.length);

		// 	// Get the file name
		// 	uploadedFiles.forEach(file => console.log('file-----'+JSON.stringify(file)));
		// } else {
		// 	//alert('False');
		// console.log('checkSpec2');
        //     console.log(checkSpecialUploadPass);
		// 	console.log('Get error:');
		// 	console.log(component.get('v.errList'));
        //     //component.set("v.fileToDelList",newFiles[0].Id);
        //     //component.set("v.isDelFile",true);
        //     //this.addToDeleteList(component, event, helper);
        //     //this.removeFile(component, event, helper);

        //     component.set("v.fileToDelList",newFiles[0].Id);
        //     var action = component.get("c.addToDeleteList");
        //     //action.setParams({ "attachmentIds": fileToDelList });
		// 	action.setCallback(this, function (response) {
        //             var state = response.getState();
        //             if (state === "SUCCESS") {
        //                 console.log('delete successful')
        //             } else {
        //                 console.error("Failed to delete attachments");
        //             }
        //         });
        //      $A.enqueueAction(action);
        // }
    },

    removeFile: function (component, event, helper) {
        // var fileNameToRemove = event.getSource().get("v.value");
        var checkAttachId = event.currentTarget.getAttribute("data-value");
        var newFileList = component.get("v.newFileList");
        console.log('checkAttachId---'+checkAttachId);

        newFileList = newFileList.filter(function (file) {
            return file.Id !== checkAttachId;
        });
		console.log('newFileList---'+newFileList);
        component.set("v.newFileList", newFileList);

        let delFileCheck = JSON.parse(JSON.stringify(component.get("v.fileToDelList")));
        console.log(delFileCheck);
        if(delFileCheck.length > 0) {
            //var attachmentId = delFileCheck[0];
            var attachmentId = delFileCheck;
        } else {
            console.log('im2');
	        var attachmentId = event.currentTarget.getAttribute("data-value");
        }

        // Add to the deletion list
        component.set("v.fileToDelList", [...component.get("v.fileToDelList"), attachmentId]);
        console.log(component.get("v.fileToDelList"));

        // component.set('v.isDelFile',true);

        //helper.handleFilesChange(component);
        //component.set("v.isUpload", true);
        //component.set("v.fileToDelList",newFileList);

		//component.set('v.isDelFile',true)

        /*
        var action = component.get("c.deleteAttachments");
                action.setParams({
                    "attachmentIds": component.get("v.newFileList")
                });
                action.setCallback(this, function (response) {
                    let state = response.getState();
                    console.log('State = '+state);
                    if (state === "SUCCESS") {
                    	console.log('delete success');
                    } else {
                     	console.log('delete error');
                    }
                });
        */
    },

    uploadFiles: function (component, event, helper) {
        if (component.get('v.isUpload')) {
            if (component.find("fileId").get("v.files") == undefined) {
                helper.showToast('Select files', false);
                return;
            }
            if (component.find("fileId").get("v.files").length > 0) {
                var s = component.get("v.FilesUploaded");
                var fileName = "";
                var fileType = "";
                var fileCount = component.find("fileId").get("v.files").length;
                var oldUploadedFile = component.get('v.uploadedFile');
                var uploadedFileList = [];
                var newFileList = component.get('v.newFileList')
                console.log('newFileList uploadFiles---'+newFileList);
                console.log('fileCount uploadFiles---'+fileCount);
                if (fileCount > 0) {
                    for (var i = 0; i < fileCount; i++) {
                         console.log('file name i uploadFiles---'+component.find("fileId").get("v.files")[i].name);
                        if(newFileList.includes(component.find("fileId").get("v.files")[i].name)){
                            var currentFileName = component.find("fileId").get("v.files")[i].name;
                        uploadedFileList.push(currentFileName);
                        helper.uploadHelper(component, event, component.find("fileId").get("v.files")[i]);
                        }//add if
                    }
                    console.log('uploadedFileList uploadFiles---'+uploadedFileList);
                    	component.set("v.newFileList", []);
                    	var newUploadedFile = uploadedFileList.join(',');
                    	var uploadedFile = "";
                    	if (oldUploadedFile != undefined) {
                        	uploadedFile = oldUploadedFile + ',' + newUploadedFile;
                    	} else {
                        	uploadedFile = newUploadedFile;
                    	}
                    	console.log('FILEUP-->uploadFiles-->',uploadedFile)

                    	component.set("v.uploadedFile", uploadedFile);

                    	console.log('uploadFiles-->uploadedFile-->',component.get('v.uploadedFile'))

                    	component.set("v.isUploadSuccess", true);
                }
            } else {
                helper.showToast("Please Select a Valid File", false);
            }
            component.set('v.isUpload', false);
        }
    },

    handleDeleteNewAttachments: function (component, event, helper) {
        console.log('handleDeleteNewAttachments');
        component.set("v.showLoadingSpinner", true);

        let attachmentId = event.currentTarget.getAttribute("data-value");
        let fileToDelList = component.get("v.fileToDelList");
        let attachmentIds = [];
        attachmentIds.push(attachmentId);

        if(attachmentId) {
            var action = component.get("c.deleteAttachments");
            action.setParams({ "attachmentIds": attachmentIds });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {

                    var deletedFileNames = response.getReturnValue();
                    if(deletedFileNames) {
                        fileToDelList = [...fileToDelList, attachmentId];
                        component.set("v.fileToDelList", fileToDelList);

                        let attachments = component.get("v.newFileList");

                        attachments = attachments.filter((attachment) => { return !fileToDelList.includes(attachment.Id) });
                        component.set("v.newFileList", attachments);
                        helper.updateUploadedFile(component, helper, false);
                    }
                    component.set("v.showLoadingSpinner", false);
                } else {
                    console.error("Failed to delete attachments");
                    component.set("v.showLoadingSpinner", false);
                }
            });
            $A.enqueueAction(action);
        }
    },

    handleDeleteUploadedAttachments: function (component, event, helper) {
        console.log('handleDeleteUploadedAttachments');

        let attachmentId = event.currentTarget.getAttribute("data-value");
        let fileToDelList = component.get("v.fileToDelList");
        fileToDelList = [...fileToDelList, attachmentId];
        component.set("v.fileToDelList", fileToDelList);

        let attachments = component.get("v.attachments");

        attachments = attachments.filter((attachment) => { return !fileToDelList.includes(attachment.Id) });
        component.set("v.attachments", attachments);

        helper.updateUploadedFile(component, helper, false);
    },

    addToDeleteList: function (component, event, helper) {
        console.log('addToDeleteList');
        console.log('fileToDel');
        console.log(component.get("v.fileToDelList"));

        let delFileCheck = JSON.parse(JSON.stringify(component.get("v.fileToDelList")));
        console.log(delFileCheck);
        if(delFileCheck.length > 0) {
            //var attachmentId = delFileCheck[0];
            var attachmentId = delFileCheck;
        } else {
            console.log('im2');
	        var attachmentId = event.currentTarget.getAttribute("data-value");
        	// Add to the deletion list
    	    component.set("v.fileToDelList", [...component.get("v.fileToDelList"), attachmentId]);
	        console.log(component.get("v.fileToDelList"));
        }
        console.log('attId');
        console.log(attachmentId);
        var attachments = component.get("v.attachments");
        console.log(attachments);
        //var updatedAttachments = attachments;

        if(attachmentId.length > 0) {
            var getErrName = component.get('v.errNames');
            var newFileList = component.get("v.newFileList");
            getErrName.forEach(function(attId){
            //delFileCheck.forEach(function(attId){
           		var checkAttachId = attId;
        		// Remove from the attachments list
        		//var attachments = component.get("v.attachments");
        		attachments = component.get("v.attachments");
                console.log('old attachments');
                console.log(attachments);
        		var updatedAttachments = attachments.filter(function (attachment) {
            		return attachment.Id !== checkAttachId;
        		});
        		component.set("v.attachments", updatedAttachments);
        		console.log('new attachments');
        		console.log(updatedAttachments);

       			console.log('fileToRemove---'+checkAttachId);
				newFileList = newFileList.filter(function (file) {
            		return file.Id !== checkAttachId;
                    // return file !== checkAttachId;
        		});
        		console.log('New newFileList -- ');
        		console.log(newFileList);
        	});
        }
		component.set("v.newFileList", newFileList);
		// component.set('v.isDelFile',true)
    },


    deleteAttachment: function (component, event, helper) {
			console.log('enter del function');
        if (component.get('v.isDelFile')) {
            var fileToDelList = component.get("v.fileToDelList");
			console.log('doFileToDel');
            console.log(fileToDelList);
            if (fileToDelList.length > 0) {
                var action = component.get("c.deleteAttachments");
                action.setParams({ "attachmentIds": fileToDelList });

                action.setCallback(this, function (response) {
                    var state = response.getState();
                    if (state === "SUCCESS") {
                        // Clear the delete list and refresh the attachments list after deletion
                        var uploadedFile = component.get("v.uploadedFile");
                        var deletedFileNames = response.getReturnValue();

                        helper.updateUploadedFile(component, helper, false);
                        // var updatedUploadedFile = uploadedFile.split(',').filter(file => !deletedFileNames.includes(file)).join(',');
                        // component.set("v.uploadedFile", updatedUploadedFile);
                        // component.set("v.isUploadSuccess", true);
                        // component.set("v.fileToDelList", []);
                        // //helper.fetchAttachments(component);
                        // helper.fetchAttachmentsSpecial(component);
                    } else {
                        console.error("Failed to delete attachments");
                    }
                });
                $A.enqueueAction(action);
            } else {
                console.warn("No attachments selected for deletion.");
            }
            component.set('v.isDelFile', false);
        }
    },

    previewAttachment: function (component, event, helper) {
        var attachmentId = event.getSource().get("v.value");

        // Navigate to the preview page for the attachment
        var navEvt = $A.get("e.force:navigateToSObject");
        navEvt.setParams({
            "recordId": attachmentId,
            "slideDevName": "related"
        });
        navEvt.fire();
    },

    fetchAttachments: function (component, event, helper) {
        if (component.get('v.isFetchAttachments')) {
            //helper.fetchAttachments(component);

            //helper.fetchAttachmentsSpecial(component);
            component.set('v.isFetchAttachments', false);
        }
    },
    onSave: function (component, event, helper) {
        return new Promise(function (resolve, reject) {
			// Show overload loading
            debugger
            helper.updateUploadedFile(component, helper, true);
            // var uploadedAttachments = component.get("v.attachments");
            // var newFileList = component.get("v.newFileList");
            // var allUploadItems = [];

            // if(uploadedAttachments) {
            //     uploadedAttachments.forEach((item) => {
            //         allUploadItems.push(item);
            //     });
            // }

            // if(newFileList) {
            //     newFileList.forEach((item) => {
            //         allUploadItems.push({
            //             Id: item.Id,
            //             Title: item.Title,
            //             IsSaved: true,
            //         });
            //     });
            // }
            // component.set("v.jsonFileList", allUploadItems);
            // console.log('allUploadItems', allUploadItems);

			let recordId = component.get('v.recordId');
            let fileToDelList = component.get("v.fileToDelList");

            if (fileToDelList && fileToDelList.length > 0) {
                component.set("v.showLoadingSpinner", true);
                console.log('doFileToDel');
                console.log(fileToDelList);
                if (fileToDelList.length > 0) {
                    var action = component.get("c.deleteAttachments");
                    action.setParams({ "attachmentIds": fileToDelList });

                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            // Clear the delete list and refresh the attachments list after deletion
                            var uploadedFile = component.get("v.uploadedFile");
                            var deletedFileNames = response.getReturnValue();
                            var updatedUploadedFile = uploadedFile.split(',').filter(file => !deletedFileNames.includes(file)).join(',');
                            component.set("v.uploadedFile", updatedUploadedFile);
                            component.set("v.isUploadSuccess", true);
                            component.set("v.fileToDelList", []);
                            //helper.fetchAttachments(component);
                            // helper.fetchAttachmentsSpecial(component);
                        } else {
                            console.error("Failed to delete attachments");
                        }
                        component.set("v.showLoadingSpinner", false);
                        resolve(true);
                    });
                    $A.enqueueAction(action);
                } else {
                    component.set("v.showLoadingSpinner", false);
                    console.warn("No attachments selected for deletion.");
                }
                component.set('v.isDelFile', false);
            }
            else {
                resolve(true);
            }
			// // Save opportunity
			// component.lax
			// 	.enqueue('c.saveRequestDetailForm', {
			// 		opportunity: record_opportunity,
			// 	})
			// 	.then((result) => {
			// 		if (result.success) {
			// 			helper.showToast(component, 'success', 'Successfully saved.');

			// 			resolve(true);
			// 		} else {
			// 			helper.showToast(component, 'error', result.message);
			// 		}
			// 	})
			// 	.catch((err) => {
			// 		helper.showToast(component, 'error', err.message);
			// 	})
			// 	.finally(() => {

            //         component.set("v.showLoadingSpinner", false);
			// 	});
		    // });
        });
    },
    deleteFiles: function (component, helper, attachmentIds) {
        return new Promise(function (resolve, reject) {

            var action = component.get("c.deleteAttachments");
            action.setParams({ "attachmentIds": attachmentIds });

            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var deletedFileNames = response.getReturnValue();
                    return deletedFileNames;
                    resolve(true);
                } else {
                    console.error("Failed to delete attachments");
                    reject(Error("Failed to delete attachments"));
                }
            });
            $A.enqueueAction(action);
        });
    }
})