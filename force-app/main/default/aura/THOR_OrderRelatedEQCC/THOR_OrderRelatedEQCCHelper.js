({
    retrieveRelated : function(component, event) {

        let action = component.get("c.getRelatedEQCCs");

        action.setParams({ orderIdentifier : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                let returnValue = response.getReturnValue();
                let checkedSheetsAmount = 0;
                component.set("v.relatedEQCCCheckSheets", returnValue);

                returnValue.forEach((headerSheet) => {
                    let headerSheets = headerSheet.sheets;
                    checkedSheetsAmount = 0;

                    headerSheet.hasPendingForApproval = false;
                    headerSheet.isPolluted = false;
                    headerSheet.hasSeveralCheckedSheets = false;
                    headerSheet.isManuallyCreated = false;
                    headerSheets.forEach((wrapperSheet) => {
                        checkedSheetsAmount++;
                        if (wrapperSheet.status == 'Pending for approval') {
                            headerSheet.hasPendingForApproval = true;
                        }
                        if (wrapperSheet.isPolluted) {
                            headerSheet.isPolluted = true;
                        }
                        if (wrapperSheet.isManuallyCreated) {
                            headerSheet.isManuallyCreated = true;
                        }
                    });
                    if (checkedSheetsAmount > 1) {
                        headerSheet.hasSeveralCheckedSheets = true;
                    }
                });

                component.set("v.RelatedEQCCs", returnValue);
            }
            else if (state === "INCOMPLETE") {
                // do something
            }
            else if (state === "ERROR") {
                let errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " +
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }

            this.stopLoading(component);
        });

        $A.enqueueAction(action);
    },

    makeToast: function(type, title, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },

    deleteEQCC: function(component, event, helper, recordToDelete){
        var checkManualCreated = component.get("c.checkIfManuallyCreated");
        checkManualCreated.setParams({
            recordId: recordToDelete
        });
        // Check if manually created. If not manually created, we need to abort and not delete any records
        checkManualCreated.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var returnedCheck = response.getReturnValue();
                // true if all of the records were manually created
                if(returnedCheck){
                    var action = component.get("c.deleteEQCCHeader");
                    action.setParams({
                        recordId: recordToDelete
                    });
                    action.setCallback(this, function (response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            var returnedItem = response.getReturnValue();
                            if(returnedItem){
                                helper.makeToast('success', "Delete Success", "Record was deleted successfully!");
                                helper.retrieveRelated(component, event);
                            }else{
                                helper.makeToast("error", "Error", "Something went wrong when trying to delete the record, please check with your Salesforce Admin.");
                            }
                        } else if (state === "ERROR") {
                            var errors = response.getError();
                            if (errors) {
                                if (errors[0] && errors[0].message) {
                                    console.log("Error message: " +
                                        errors[0].message);
                                }
                            } else {
                                console.log("Unknown error");
                            }
                        }
                        
                        this.stopLoading(component);
                    });
                    $A.enqueueAction(action);
                }else{
                    helper.makeToast("error", "Error", "Can not delete records that were not manually created.");
                }
            } else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                            errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(checkManualCreated);
    },
    
    stopLoading : function(component) {
        var stopLoadingEvent = component.getEvent("stopLoadingEvent");
        stopLoadingEvent.setParams({
            "target": "stopLoading"
        });
        stopLoadingEvent.fire();
    }
})