({
    MAX_FILE_SIZE: 4500000, //Max file size 4.5 MB 
    CHUNK_SIZE: 750000, //Chunk Max size 750Kb 

    uploadHelper: function (component, event, f) {
        component.set("v.showLoadingSpinner", true);
        var file = f;
        var self = this;
        if (file.size > self.MAX_FILE_SIZE) {
            component.set("v.showLoadingSpinner", false);
            //component.set("v.fileName", 'Alert : File size cannot exceed ' + self.MAX_FILE_SIZE + ' bytes.\n' + ' Selected file size: ' + file.size);
            component.set("v.fileName", 'The file number exceeds the maximum limit (at 10 files)');
            return;
        }

        // Convert file content in Base64
        var objFileReader = new FileReader();
        objFileReader.onload = $A.getCallback(function () {
            var fileContents = objFileReader.result;
            var base64 = 'base64,';
            var dataStart = fileContents.indexOf(base64) + base64.length;
            fileContents = fileContents.substring(dataStart);
            self.uploadProcess(component, file, fileContents);
        });

        objFileReader.readAsDataURL(file);
    },

    checkConditions: function(component, event, helper, newFiles) {
        return new Promise((resolve,reject)=>{
            let that = this;
            var errList = [];
            var errIds = [];
            let documentIds = newFiles.map((item) => { return item.documentId });

            var action = component.get("c.getAttachmentDetailByIds");
            action.setParams({
                "recordId": component.get("v.recordId"),
                "contentDocumentIds" : documentIds
            });
            action.setCallback(this, function (response) {
                let state = response.getState();
                console.log('State = '+state);
                if (state === "SUCCESS") {
                    var fileInfos = response.getReturnValue();
                    if(fileInfos) {
                        fileInfos.forEach((eachFileInfo) => {
                            
                            if(that.isOverAllFileLimit(component, helper, eachFileInfo)) {
                                errIds.push(eachFileInfo.Id);
                                var totalFilesErr = "This total files exceeds the limit allowed (10 files) and cannot be attached";
                                
                                if(!errList.includes(totalFilesErr)) {
                                    errList.push(totalFilesErr);
                                }
                            }
                            else if(that.isTotalOverSizeLimit(component, helper, eachFileInfo)) {
                                errIds.push(eachFileInfo.Id);
                                var totalSizeErr = "The total file size exceeds the limit allowed (at 25 MB) and cannot be attached";
                                
                                if(!errList.includes(totalSizeErr)) {
                                    errList.push(totalSizeErr);
                                }
                            }
                            else if(that.isImageOverSizeLimit(component, helper, eachFileInfo)) {
                                errIds.push(eachFileInfo.Id);
                                var imageFileLimErr = "The picture size exceeds the limit allowed (at 1 MB per picture) and cannot be attached";
                                
                                if(!errList.includes(imageFileLimErr)) {
                                    errList.push(imageFileLimErr);
                                }
                            }
                            else if(that.isNonImageOverSizeLimit(component, helper, eachFileInfo)) {
                                errIds.push(eachFileInfo.Id);
                                var nonImgFileLimErr = "The file size exceeds the limit allowed (at 5 MB per file) and cannot be attached";
                                
                                if(!errList.includes(nonImgFileLimErr)) {
                                    errList.push(nonImgFileLimErr);
                                }
                            }
                            else {
                                var newFileList = component.get("v.newFileList") || [];
                                newFileList.push({
                                    Id: eachFileInfo.Id,
                                    Title: eachFileInfo.Title,
                                    ContentSize: eachFileInfo.ContentSize,
                                    IsSaved: false,
                                });
                                component.set("v.newFileList", newFileList);
                            }
                            component.set('v.errList', errList);
                            component.set('v.errIds', errIds);
                        })
                    }
                    resolve(errIds);
                }
                else {
                    console.error("Failed to fetch attachments");
                    reject(false);
                }
            })
            $A.enqueueAction(action);
        });
    },

    isOverAllFileLimit: function(component, helper, file) {
        var newFileList = component.get("v.newFileList") || [];
        var attachments = component.get("v.attachments") || [];
        var totalFilesLimit = 10; // 10 Attachments

        var isOverLimit = newFileList.length + attachments.length + 1 > totalFilesLimit;
        return isOverLimit;
    },

    isImageOverSizeLimit: function(component, helper, file) {
        var imageSizeLimit = 1048576;  // 1MB
        let isImageOverSizeLimit = false;
        if(file.FileType == "PNG" || file.FileType == "JPG") {
            isImageOverSizeLimit = file.ContentSize > imageSizeLimit;
        }
        return isImageOverSizeLimit;
    },

    isNonImageOverSizeLimit: function(component, helper, file) {
        var nonImgSizeLimit = 5242880;  // 5MB
        let isNonImageOverSizeLimit = file.ContentSize > nonImgSizeLimit;

        return isNonImageOverSizeLimit;
    },

    isTotalOverSizeLimit: function(component, helper, file) {
        var totalSizeLimit = 26214400; // 25MB

        // TODO: not complete yet
        // calculate total size limit 
        const newFileList = component.get("v.newFileList");
        const uploadedAttachments = component.get("v.tempattachments");
        
        let totalSize = 0;
        newFileList.forEach(file => {
            totalSize = totalSize + file.ContentSize;
        });
        uploadedAttachments.forEach(file => {
            totalSize = totalSize + file.ContentSize;
        });

        let isTotalOverSizeLimit = totalSize > totalSizeLimit;

        return isTotalOverSizeLimit;
    },

    
    checkSpecialConditions : function(component, event, docNames, byId) {
        return new Promise((resolve,reject)=>{
            console.log('aa');
            var action = component.get("c.getAttachmentDetails");
                action.setParams({
                    "recordId": component.get("v.recordId"),
                    "uploadedList" : docNames,
                    "byId" : byId
                });
                action.setCallback(this, function (response) {
                    let state = response.getState();
                    console.log('State = '+state);
                    if (state === "SUCCESS") {
                            console.log('done');
                            component.set('v.errList',[]);
                            component.set('v.errIds',[]);
                            component.set('v.errNames',[]);
                            var newFiles = JSON.parse(JSON.stringify(event.getParam("files")));
                        console.log('----newFiles----');
                        console.log(newFiles);
                            var res = response.getReturnValue();
                        console.log('----resFiles----');
                            console.log(res);
                            var newFileSize = 0;
                            var newNonImgFileSize = 0;
                            var totalFiles = 0;
                            var totalSize = 0;
                            var newFileLimitCheck = false;
                            var newNonImgFileLimitCheck = false;
                            var totalSizeLimitCheck = false;
                            var totalFilesLimitCheck = false;
                            var newSizeLimit = 1048576;  // 1MB
                            var newNonImgSizeLimit = 5242880;  // 5MB
                            var totalSizeLimit = 26214400; // 25MB
                            var totalFilesLimit = 10; // 10 Attachments
                        	var savedUploads = component.get("v.committeeAttachment__c") || "{}";
                            console.log('saveduploads : ');
                            console.log(savedUploads);
                            var uploadsToCheck = JSON.parse(savedUploads);
                            console.log('json saveduploads : ');
                            console.log(uploadsToCheck);
                            var uploadedArray = {};
                            var tempId = '';
                        	var errIds = [];
                        	var errNames = [];
                        	if(Object.keys(uploadsToCheck).length > 0) {
                            	uploadsToCheck.forEach(function(attList){
                                	tempId = attList.Id;
                                	uploadedArray[tempId] = attList;
                            	});
                    		}
                        console.log('committeattach');
                        console.log(component.get("v.committeeAttachment__c"));
                            res.forEach(function(objList,objKey){
                                newFiles.forEach(function(newList,newKey){
                                    console.log('New files round : '+newKey);
                                    console.log(objList);
                                    if(objList.Id == newList.documentId) {
                                    	if(objList.FileType == "PNG" || objList.FileType == "JPG") {
                                    		newFileSize = objList.ContentSize;
                                    		newFileLimitCheck = objList.ContentSize > newSizeLimit ? true : false;
                                                totalFiles++;
                                                totalSize += objList.ContentSize;
                                        	if(objList.ContentSize > newSizeLimit) { 
                                                errIds.push(objList.Id);
                                                errNames.push(objList.Title+"."+objList.FileExtension);
                                            } else {
                                                if((totalSize > totalSizeLimit) || totalFiles > totalFilesLimit)  { 
                                            		//if(!(objList.Id in errIds)) {    
	                                            		errIds.push(objList.Id);
                                                    	errNames.push(objList.Title+"."+objList.FileExtension);
                                        			//}
                                        		}
                                            }
                                    	} else {
                                    		newNonImgFileSize = objList.ContentSize;
                                    		newNonImgFileLimitCheck = objList.ContentSize > newNonImgSizeLimit ? true : false;
                                                totalFiles++;
                                                totalSize += objList.ContentSize;
                                    		if(objList.ContentSize > newSizeLimit) { 
                                                errIds.push(objList.Id);
                                                errNames.push(objList.Title+"."+objList.FileExtension);
                                            } else {
                                                if((totalSize > totalSizeLimit) || totalFiles > totalFilesLimit)  { 
                                            		//if(!(objList.Id in errIds)) {    
	                                            		errIds.push(objList.Id);
                                                		errNames.push(objList.Title+"."+objList.FileExtension);
                                        			//}
                                        		}
                                            }
                                    	}
                                    	//totalFiles++;
                                    	//totalSize += objList.ContentSize;
                                    	
                                	}
                                });
                              /*  
                                if(objList.Id == newFiles[0].documentId) {
                                    if(objList.FileType == "PNG" || objList.FileType == "JPG") {
                                    	newFileSize = objList.ContentSize;
                                    	newFileLimitCheck = objList.ContentSize > newSizeLimit ? true : newFileLimitCheck;
                                        if(objList.ContentSize > newSizeLimit) { errIds.push(objList.Id);}
                                    } else {
                                    	newNonImgFileSize = objList.ContentSize;
                                    	newNonImgFileLimitCheck = objList.ContentSize > newNonImgSizeLimit ? true : newNonImgFileLimitCheck;
                                    	if(objList.ContentSize > newSizeLimit) { errIds.push(objList.Id);}
                                    }
                                    totalFiles++;
                                    totalSize += objList.ContentSize;
                                    if((totalSize > totalSizeLimit) || totalSize > totalFiles)  { errIds.push(objList.Id);}
                                } else {
                                    console.log('newFile)');
                                */    
                                if(objList.Id in uploadedArray) {
                                        if(uploadedArray[objList.Id].isSaved == true) {
                                            totalFiles++;
                                            totalSize += objList.ContentSize;
                                        }
                                    } 
                                //}
                                //var checkFileList = component.get("v.newFileList");
                                //checkFileList.forEach(function(checkF){
                                //	console.log(checkF);        
                                //})
                                //totalFiles++;
                                //totalSize += objList.ContentSize;
                            })
                            totalSizeLimitCheck = totalSize > totalSizeLimit ? true : false;
                            totalFilesLimitCheck = totalFiles > totalFilesLimit ? true : false;
                            
                            console.log('newSize : '+newFileSize);
                            console.log('newSizeLimit : '+newFileLimitCheck);
                            console.log('newNonImgFileSize : '+newNonImgFileSize);
                            console.log('newNonImgFileLimitCheck : '+newNonImgFileLimitCheck);
                            console.log('totalSize : '+totalSize);
                            console.log('totalSizeLimit : '+totalSizeLimitCheck);
                            console.log('totalFiles : '+totalFiles);
                            console.log('totalFilesLimit : '+totalFilesLimitCheck);
                        
                            if(!newFileLimitCheck && !newNonImgFileLimitCheck && !totalSizeLimitCheck && !totalFilesLimitCheck) {
                                console.log('TrueFile');
                                resolve(false);
                            } else {
                                console.log('FalseFile');
                                
                                var errList = [];
                                var newFileLimErr = "The picture size exceeds the limit allowed (at 1 MB per picture) and cannot be attached";
                                var newNonImgFileLimErr = "The file size exceeds the limit allowed (at 5 MB per file) and cannot be attached";
                                var totalSizeErr = "The total file size exceeds the limit allowed (at 25 MB) and cannot be attached";
                                var totalFilesErr = "This total files exceeds the limit allowed (10 files) and cannot be attached";
                                if(newFileLimitCheck == true) {
                                    errList.push(newFileLimErr);
                                }
                                if(newNonImgFileLimitCheck == true) {
                                    errList.push(newNonImgFileLimErr);
                                }
                                if(totalSizeLimitCheck == true) {
                                    errList.push(totalSizeErr);
                                }
                                if(totalFilesLimitCheck == true) {
                                    errList.push(totalFilesErr);
                                }
                                console.log('seterr');
                                console.log(errList);
                                component.set('v.errList',errList);
                                component.set('v.errIds',errIds);
                                component.set('v.errNames',errNames);
                                console.log('seterrIds');
                                console.log(errIds);
                                console.log('seterrNames');
                                console.log(errNames);
                                resolve(errList);
                            }
                        } else {
                            console.error("Failed to fetch attachments");
                            reject(false);
                    }
                });
                $A.enqueueAction(action);
        })
    },
    
    uploadProcess: function (component, file, fileContents) {
        var startPosition = 0;
        var endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);

        this.uploadInChunk(component, file, fileContents, startPosition, endPosition);
    },


    uploadInChunk: function (component, file, fileContents, startPosition, endPosition) {
        var getchunk = fileContents.substring(startPosition, endPosition);
        component.set('v.isUploadDone', false);
        var action = component.get("c.saveFiles");
        action.setParams({
            parentId: component.get("v.recordId"),
            fileName: file.name,
            base64Data: encodeURIComponent(getchunk),
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                // update the start position with end postion
                startPosition = endPosition;
                endPosition = Math.min(fileContents.length, startPosition + this.CHUNK_SIZE);
                if (startPosition < endPosition) {
                    this.uploadInChunk(component, file, fileContents, startPosition, endPosition);
                } else {
                    // this.showToast('File is uploaded successfully', true);
                    component.set("v.showLoadingSpinner", false);
                    component.set('v.newFileList', []);
                    console.log('uploadfile---');
                    component.set('v.isUploadDone', true);
                    console.log('uploadfile---'+component.get('v.isUploadDone'));
                    /*
                    var compEvent = component.getEvent("uploadevent");
                    
                    console.log('compEvent---'+compEvent);
                    compEvent.setParams({
                        "message" : 'true'
                    });
                    console.log('compEvent--2-'+compEvent);
                    compEvent.fire();*/
                    this.fetchAttachments(component);
                    
                }
            } else if (state === "INCOMPLETE") {
                this.showToast("From server: " + response.getReturnValue(), false);
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    showToast: function (message, isSuccess) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            // "title": isSuccess ? "Success!" : "Error!",
            "type": isSuccess ? "success" : "error",
            "message": message
        });
        toastEvent.fire();
    },

    fetchAttachments: function (component) {
        console.log('---upload file in child----'+component.get("v.uploadedFile"));
        console.log('---component.get(v.recordId)----'+component.get('v.recordId'));
        var action = component.get("c.getAttachments");
        action.setParams({ 
            "recordId": component.get('v.recordId'),
            "uploadedList": component.get('v.uploadedFile')
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('---upload file in child--reutrn--'+JSON.stringify(response.getReturnValue()));
                component.set("v.attachments", response.getReturnValue());
                //component.set("v.attachments", [{"Id":"0691m000003O3RKAA0","Title":"Credit Score.postman_collection - Copy (2).json","isUnsaved":true},{"Id":"0691m000003O3RUAA0","Title":"Credit Score.postman_collection - Copy.json","isUnsaved":true},{"Id":"0691m000003O3ReAAK","Title":"Credit Score.postman_collection.json","isUnsaved":true}]);
                console.log('---upload file in child--reutrn-attachments-'+JSON.stringify(component.get("v.attachments")));
                
            } else {
                console.error("Failed to fetch attachments");
            }
        });
        component.set('v.isFetchAttachments', false);
        $A.enqueueAction(action);
    },
    
    
    fetchAttachmentsSpecial: function (component) {
        console.log('---upload file in child----'+component.get("v.uploadedFile"));
        console.log('---component.get(v.recordId)----'+component.get('v.recordId'));
        var action = component.get("c.getAttachmentDetails");
        action.setParams({ 
            "recordId": component.get('v.recordId'),
            "uploadedList": "",
            "byId":false
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('success response');
                console.log(response);
                console.log('result response');
                var responseResult = response.getReturnValue();
                console.log(responseResult);
                
                console.log('attachment results');
                console.log(component.get('v.attachments'));
                console.log('uploaded results');
                console.log(component.get('v.uploadedFile'));
                //component.set("v.attachments", response.getReturnValue());
                var dataCheck = JSON.parse(JSON.stringify(component.get("v.uploadedFile")));
                console.log(dataCheck);
                if(dataCheck.length > 0) {
                    console.log('use vupload');
                    console.log(component.get('v.uploadedFile'));
                    
                    console.log(JSON.stringify(component.get('v.uploadedFile')));
                    
                    console.log(JSON.parse(JSON.stringify(component.get('v.uploadedFile'))));
                	component.set("v.attachments",JSON.parse(component.get('v.uploadedFile')));
                	component.set("v.tempattachments", JSON.parse(component.get('v.uploadedFile')));
                } else {
                    console.log('use result');
                	component.set("v.attachments", response.getReturnValue());
                	component.set("v.tempattachments", response.getReturnValue());
                } 
                console.log('---upload file in child--reutrn-attachments-'+JSON.stringify(component.get("v.attachments")));
          		console.log('v attachments');
                console.log(component.get("v.attachments"));
        		//component.set('v.isFetchAttachments', true);      
            } else {
                console.error("Failed to fetch attachments");
            }
        });
        component.set('v.isFetchAttachments', false);
        
        $A.enqueueAction(action);
    },

    updateUploadedFile: function (component, helper, isSave) {
        var uploadedAttachments = (isSave == true) ? component.get("v.attachments") : component.get("v.tempattachments");
        var newFileList = component.get("v.newFileList");
        var allUploadItems = [];

        if(uploadedAttachments) {
            uploadedAttachments.forEach((item) => {
                allUploadItems.push({
                    Id: item.Id,
                    Title: item.Title,
                    ContentSize: item.ContentSize,
                    IsSaved: true,
                });
            });
        }

        if(newFileList) {
            newFileList.forEach((item) => {
                allUploadItems.push({
                    Id: item.Id,
                    Title: item.Title,
                    ContentSize: item.ContentSize,
                    IsSaved: isSave,
                });
            });
        }
        component.set("v.jsonFileList", allUploadItems);
    }
    
})