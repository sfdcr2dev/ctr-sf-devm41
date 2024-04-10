({
    doInit: function (component, event, helper) {
        helper.getFileUploadInfo(component, event, helper)
            .then(
                $A.getCallback((returnValue) => {
                    const fieldName = component.get("v.fieldName");
                    const files = helper.tryParseJSON(returnValue[fieldName]) || [];

                    const savedAttachments = helper.filterSavedAttachments(files);
                    const unsavedAttachments = helper.filterUnsavedAttachments(files);

                    component.set("v.uploadedAttachments", savedAttachments);
                    if (unsavedAttachments.length > 0) {
                        helper.cleanupUnsavedAttachments(component, event, helper, files);
                    }
                }),
                $A.getCallback((errors) => {
                    console.error(errors);
                }))
            .catch($A.getCallback((errors) => {
                console.error(errors);
            }));
    },
    getMergedAttachments: function (component, event, helper) {
        const newAttachments = component.get("v.newAttachments");
        const uploadedAttachments = component.get("v.uploadedAttachments");

        const markSavedNewAttachment = newAttachments.map((file) => {
            file.IsSaved = true;
            return file;
        });

        return helper.mergeAttachments(uploadedAttachments, [], markSavedNewAttachment);
    },
    saveAttachments: function (component, event, helper) {
        const newAttachments = component.get("v.newAttachments");
        const uploadedAttachments = component.get("v.uploadedAttachments");
        const deletedAttachments = component.get("v.deletedAttachments");

        const markSavedNewAttachment = newAttachments.map((file) => {
            file.IsSaved = true;
            return file;
        });

        const deletedAttachmentIds = deletedAttachments.map((file) => { return file.Id; });
        const mergeAttachments = helper.mergeAttachments(uploadedAttachments, [], markSavedNewAttachment);

        return helper.deleteAttachments(component, event, helper, deletedAttachmentIds)
            .then(
                $A.getCallback(function () {
                    return helper.updateFileUploadInfo(component, event, helper, JSON.stringify(mergeAttachments));
                })
            );

        // return helper.updateFileUploadInfo(component, event, helper, JSON.stringify(mergeAttachments));
    },
    deletePendingAttachments: function (component, event, helper) {
        const deletedAttachments = component.get("v.deletedAttachments");
        const deletedAttachmentIds = deletedAttachments.map((file) => { return file.Id; });
        return helper.deleteAttachments(component, event, helper, deletedAttachmentIds)
            .then(
                $A.getCallback(function () {
                    component.set("v.deletedAttachments", []);
                })
            );
    },
    handleUploadFinished: function (component, event, helper) {
        component.set("v.isUploading", true);

        const files = event.getParam("files");
        helper.getAttachmentsByIds(component, event, helper, files)
            .then(
                $A.getCallback((returnValue) => {
                    return helper.checkAttachmentRules(component, event, helper, returnValue);
                }),
                $A.getCallback((errors) => {
                    console.error(errors);
                }))
            .then(
                $A.getCallback((returnValue) => {
                    if ($A.util.isArray(returnValue)) {
                        const newAttachments = component.get("v.newAttachments");
                        returnValue.forEach((file) => {
                            newAttachments.push({
                                Id: file.Id,
                                Title: file.Title + '.' + file.FileExtension,
                                ContentSize: file.ContentSize,
                                IsSaved: false,
                            })
                        });
                        component.set("v.newAttachments", newAttachments);
                    }

                    const newAttachments = component.get("v.newAttachments");
                    const uploadedAttachments = component.get("v.uploadedAttachments");
                    const deletedAttachments = component.get("v.deletedAttachments");
                    const mergeAttachments = helper.mergeAttachments(uploadedAttachments, deletedAttachments, newAttachments);
                    helper.updateFileUploadInfo(component, event, helper, JSON.stringify(mergeAttachments))
                        .then($A.getCallback(function() {
                            component.set("v.isUploading", false);
                        }));
                }),
                $A.getCallback((errorAttachments) => {
                    const errorAttachmentIds = errorAttachments.map(file => file.Id);
                    helper.deleteAttachments(component, event, helper, errorAttachmentIds)
                        .then($A.getCallback(function() {
                            component.set("v.isUploading", false);
                        }));
                }))
            .catch($A.getCallback((errors) => {
                console.error(errors);
                component.set("v.isUploading", false);
            }))
    },
    handleDeleteNewAttachments: function (component, event, helper) {
        component.set("v.isUploading", true);

        const attachmentId = event.currentTarget.getAttribute("data-value");
        if (attachmentId) {
            helper.deleteAttachments(component, event, helper, [attachmentId])
                .then(
                    $A.getCallback((returnValue) => {
                        if ($A.util.isArray(returnValue) && returnValue.length > 0) {
                            const newAttachments = component.get("v.newAttachments");
                            const newAttachmentsAfterDeleted = newAttachments.filter((file) => {
                                return file.Id !== attachmentId
                            });
                            component.set("v.newAttachments", newAttachmentsAfterDeleted);
                        }

                        const newAttachments = component.get("v.newAttachments");
                        const uploadedAttachments = component.get("v.uploadedAttachments");
                        const deletedAttachments = component.get("v.deletedAttachments");
                        const mergeAttachments = helper.mergeAttachments(uploadedAttachments, deletedAttachments, newAttachments);
                        helper.updateFileUploadInfo(component, event, helper, JSON.stringify(mergeAttachments));
                    }),
                    $A.getCallback((errors) => {
                        console.error(errors);
                    }))
                .catch($A.getCallback((errors) => {
                    console.error(errors);
                }))
                .finally($A.getCallback(() => {
                    component.set("v.isUploading", false);
                }));
        }
    },
    handleDeleteUploadedAttachments: function (component, event, helper) {
        const attachmentId = event.currentTarget.getAttribute("data-value");
        if (attachmentId) {
            const uploadedAttachments = component.get("v.uploadedAttachments");
            const deletedAttachments = component.get("v.deletedAttachments");

            const file = uploadedAttachments.find((item) => { return item.Id === attachmentId });
            if (file) {
                deletedAttachments.push(file);
                component.set("v.deletedAttachments", deletedAttachments);
            }

            const newUploadedAttachments = uploadedAttachments.filter((item) => { return item.Id !== attachmentId; });
            component.set("v.uploadedAttachments", newUploadedAttachments);
        }
    },
})