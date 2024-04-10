({
    getFileUploadInfo: function (component, event, helper) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const action = component.get("c.getFileUploadInfo");
            action.setParams({
                sObjectName: component.get("v.sObjectName"),
                fieldName: component.get("v.fieldName"),
                recordId: component.get("v.recordId"),
            })
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const returnValue = response.getReturnValue();
                    resolve(returnValue);
                } else if (state === "INCOMPLETE") {
                    reject("INCOMPLETE");
                } else if (state === "ERROR") {
                    const errors = response.getError();
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    updateFileUploadInfo: function (component, event, helper, fieldValue) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const action = component.get("c.updateFileUploadInfo");
            action.setParams({
                sObjectName: component.get("v.sObjectName"),
                fieldName: component.get("v.fieldName"),
                recordId: component.get("v.recordId"),
                fieldValue: fieldValue,
            })
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const returnValue = response.getReturnValue();
                    resolve(returnValue);
                } else if (state === "INCOMPLETE") {
                    reject("INCOMPLETE");
                } else if (state === "ERROR") {
                    const errors = response.getError();
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    getAttachmentsByIds: function (component, event, helper, files) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const documentIds = files.map((item) => { return item.documentId });

            const action = component.get("c.getAttachmentsByIds");
            action.setParams({
                "recordId": component.get("v.recordId"),
                "contentDocumentIds": documentIds,
            })
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const returnValue = response.getReturnValue();
                    resolve(returnValue);
                } else if (state === "INCOMPLETE") {
                    reject("INCOMPLETE");
                } else if (state === "ERROR") {
                    const errors = response.getError();
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    checkAttachmentRules: function (component, event, helper, files) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const errorList = [];
            if ($A.util.isArray(files)) {
                const filesOverLimit = files.filter($A.getCallback(function (file) {
                    return helper.isNonImageSizeOverLimit(component, helper, file);
                }));
                if (filesOverLimit.length > 0) {
                    errorList.push("The file size exceeds the limit allowed (at 5 MB per file) and cannot be attached");
                }

                const filesNumberOverLimit = false;
                // const filesNumberOverLimit = helper.isNumberOfFilesOverLimit(component, helper, files);
                // if (filesNumberOverLimit) {
                //     errorList.push("This total files exceeds the limit allowed (10 files) and cannot be attached");
                // }

                const totalFilesSizeOverLimit = helper.isTotalSizeOverLimit(component, helper, files);
                if (totalFilesSizeOverLimit) {
                    errorList.push("The total file size exceeds the limit allowed (at 25 MB) and cannot be attached");
                }

                if (filesOverLimit.length > 0 || filesNumberOverLimit || totalFilesSizeOverLimit) {
                    component.set("v.errorList", errorList);
                    return reject(JSON.parse(JSON.stringify(files)));
                }

                resolve(files);
            } else {
                reject(files);
            }
        }));
    },
    deleteAttachments: function (component, event, helper, attachmentIds) {
        return new Promise($A.getCallback(function (resolve, reject) {
            const action = component.get("c.deleteAttachments");
            action.setParams({
                "attachmentIds": attachmentIds,
            })
            action.setCallback(this, function (response) {
                const state = response.getState();
                if (state === "SUCCESS") {
                    const returnValue = response.getReturnValue();
                    resolve(returnValue);
                } else if (state === "INCOMPLETE") {
                    reject("INCOMPLETE");
                } else if (state === "ERROR") {
                    const errors = response.getError();
                    reject(errors);
                }
            });
            $A.enqueueAction(action);
        }));
    },
    cleanupUnsavedAttachments: function (component, event, helper, files) {
        const savedAttachments = helper.filterSavedAttachments(files);
        const unsavedAttachments = helper.filterUnsavedAttachments(files);
        const unsavedAttachmentIds = unsavedAttachments.map((file) => { return file.Id });

        return helper.deleteAttachments(component, event, helper, unsavedAttachmentIds)
            .then(
                $A.getCallback(function () {
                    helper.updateFileUploadInfo(component, event, helper, JSON.stringify(savedAttachments));
                })
            );
    },
    tryParseJSON: function (json) {
        let result;
        try {
            result = JSON.parse(json);
        } catch (errors) {
            result = null;
        }
        return result;
    },
    filterSavedAttachments: function (files) {
        return files.filter((file) => {
            return file.IsSaved;
        });
    },
    filterUnsavedAttachments: function (files) {
        return files.filter((file) => {
            return !file.IsSaved;
        });
    },
    mergeAttachments: function (uploadedAttachments, deletedAttachments, newAttachments) {
        return [...uploadedAttachments, ...deletedAttachments, ...newAttachments];
    },
    isNumberOfFilesOverLimit: function (component, helper, files) {
        const totalNumberOfFilesLimit = 10;
        const newAttachments = component.get("v.newAttachments") || [];
        const uploadedAttachments = component.get("v.uploadedAttachments") || [];

        const isOverLimit = newAttachments.length + uploadedAttachments.length + files.length > totalNumberOfFilesLimit;
        return isOverLimit;
    },
    isNonImageSizeOverLimit: function (component, helper, file) {
        const nonImgSizeLimit = 5242880;  // 5MB
        const isNonImageSizeOverLimit = file.ContentSize > nonImgSizeLimit;

        return isNonImageSizeOverLimit;
    },
    isTotalSizeOverLimit: function (component, helper, files) {
        const totalSizeLimit = 26214400; // 25MB

        const newAttachments = component.get("v.newAttachments");
        const uploadedAttachments = component.get("v.uploadedAttachments");

        let totalSize = 0;
        newAttachments.forEach(file => {
            totalSize = totalSize + file.ContentSize;
        });
        uploadedAttachments.forEach(file => {
            totalSize = totalSize + file.ContentSize;
        });
        files.forEach(file => {
            totalSize = totalSize + file.ContentSize;
        });

        const isTotalSizeOverLimit = totalSize > totalSizeLimit;

        return isTotalSizeOverLimit;
    },
})