({
	setRelatedWorkClearances: function (component, event) {
		let action = component.get("c.getRelatedWorkClearances");
		// alert(component.get("v.recordId") );

		action.setParams({ notificationIdentifier: component.get("v.recordId") });
		action.setCallback(this, function (response) {
			let state = response.getState();
			if (state === "SUCCESS") {
				let returnValue = response.getReturnValue();
				// alert(JSON.stringify(returnValue));
				component.set("v.RelatedWorkClearances", returnValue);
			} else if (state === "INCOMPLETE") {
				// do something
			} else if (state === "ERROR") {
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

		});

		$A.enqueueAction(action);
	},

	hasWriteAccess: function (component, event) {
		let action = component.get('c.hasWriteAccess');
		//alert('has2');
		action.setParams({
			recordId: component.get('v.recordId')
		});

		action.setCallback(this, function (response) {
			let state = response.getState()

			if (state === 'SUCCESS') {
				// alert(response.getReturnValue());
				component.set('v.hasWriteAccess', response.getReturnValue());
			} else if (state === "ERROR") {
				let errors = response.getError()
				if (errors) {
					if (errors[0] && errors[0].message) {
						console.error("Error message: " +
							errors[0].message)
					}
				} else {
					console.log("Unknown error")
				}
			}
		});

		$A.enqueueAction(action);
	},

	parseObject: function (obj) {
		return obj ? JSON.parse(JSON.stringify(obj)) : obj;
	},

	getWorkClearances: function (component, event, helper) {
		var action = component.get("c.getWorkClearancesByFilter")
		action.setParams({
			filter: component.get("v.filter") || {},
		})
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === "SUCCESS") {
				var result = response.getReturnValue();

				component.set('v.workClearances', result.map(m => {
					m.info = `${m.Work_Clearance__c} . ${m.Functional_Location__r ? m.Functional_Location__r.Name : ''}  . ${m.Priority__c} . ${m.Main_Work_Center__c} . ${m.Description__c} . ${new Date(m.CreatedDate).toLocaleDateString('en-GB')}`
					return m
				}));

				component.set('v.workClearances_new',
					component.get('v.workClearances'))

			} else if (state === "ERROR") {
				var error = response.getError();
				console.error(error);
			}
		})

		$A.enqueueAction(action)
	},
})



// ({
//     retrieveRelated : function(component, event) {

//         let action = component.get("c.getRelatedEQCCs");

//         action.setParams({ notificationIdentifier : component.get("v.recordId") });
//         action.setCallback(this, function(response) {
//             let state = response.getState();
//             if (state === "SUCCESS") {
//                 let returnValue = response.getReturnValue();
//                 let checkedSheetsAmount = 0;
//                 component.set("v.RelatedEQCCs", returnValue);

//                 returnValue.forEach((headerSheet) => {
//                     let headerSheets = headerSheet.sheets;
//                     checkedSheetsAmount = 0;

//                     headerSheet.hasPendingForApproval = false;
//                     headerSheet.isPolluted = false;
//                     headerSheet.hasSeveralCheckedSheets = false;
//                     headerSheet.isManuallyCreated = false;
//                     headerSheets.forEach((wrapperSheet) => {
//                         checkedSheetsAmount++;
//                         if (wrapperSheet.status == 'Pending for approval') {
//                             headerSheet.hasPendingForApproval = true;
//                         }
//                         if (wrapperSheet.isPolluted) {
//                             headerSheet.isPolluted = true;
//                         }
//                         if (wrapperSheet.isManuallyCreated) {
//                             headerSheet.isManuallyCreated = true;
//                         }
//                     });
//                     if (checkedSheetsAmount > 1) {
//                         headerSheet.hasSeveralCheckedSheets = true;
//                     }
//                 });

//                 component.set("v.RelatedEQCCs", returnValue);
//             }
//             else if (state === "INCOMPLETE") {
//                 // do something
//             }
//             else if (state === "ERROR") {
//                 let errors = response.getError();
//                 if (errors) {
//                     if (errors[0] && errors[0].message) {
//                         console.error("Error message: " +
//                                     errors[0].message);
//                     }
//                 } else {
//                     console.log("Unknown error");
//                 }
//             }

//             this.stopLoading(component);
//         });

//         $A.enqueueAction(action);
//     },

//     retrieveEQCCCS : function(component, event) {

//         let action = component.get("c.getEQCCCS");

//         action.setCallback(this, function(response) {
//             let state = response.getState();
//             if (state === "SUCCESS") {
//                 let returnValue = response.getReturnValue();
//                 component.set("v.EQCCCS", returnValue);
//             }
//             else if (state === "INCOMPLETE") {
//                 // do something
//             }
//             else if (state === "ERROR") {
//                 let errors = response.getError();
//                 if (errors) {
//                     if (errors[0] && errors[0].message) {
//                         console.error("Error message: " +
//                                     errors[0].message);
//                     }
//                 } else {
//                     console.log("Unknown error");
//                 }
//             }

//             this.stopLoading(component);
//         });

//         $A.enqueueAction(action);
//     },

//     setEQCCHeader : function(component, event, EQCCChekedSheetId, EQCCHeaderId) {
//         let action = component.get("c.setEQCCHeader");
//         action.setParams({
//             currentEQCCCheckedSheetId : EQCCChekedSheetId ,
//             currentEQCCHeaderId : EQCCHeaderId
//         });

//         action.setCallback(this, function(response) {
//             let state = response.getState();
//             if (state === "SUCCESS") {
//                 var toastEvent = $A.get("e.force:showToast");
//                 toastEvent.setParams({
//                 "type": "success",
//                 "title": "Success!",
//                  "message": "Record has been inserted successfully."
//                 });
//                 toastEvent.fire();
//             }
//             else if (state === "INCOMPLETE") {
//                 // do something
//             }
//             else if (state === "ERROR") {
//                 let errors = response.getError();
//                 if (errors) {
//                     if (errors[0] && errors[0].message) {
//                         console.error("Error message: " +
//                                     errors[0].message);
//                     }
//                 } else {
//                     console.log("Unknown error");
//                 }
//             }

//             this.stopLoading(component);
//         });

//         $A.enqueueAction(action);
//     },

//     makeToast: function(type, title, message) {
//         var toastEvent = $A.get("e.force:showToast");
//         toastEvent.setParams({
//             "title": title,
//             "message": message,
//             "type": type
//         });
//         toastEvent.fire();
//     },

//     deleteEQCC: function(component, event, helper, recordToDelete){
//         var action = component.get("c.deleteEQCCHeader");
//         action.setParams({
//             recordId: recordToDelete
//         });
//         action.setCallback(this, function (response) {
//             var state = response.getState();
//             if (state === "SUCCESS") {
//                 var returnedItem = response.getReturnValue();
//                 if(returnedItem){
//                     helper.makeToast('success', "Delete Success", "Record was deleted successfully!");
//                     helper.retrieveRelated(component, event);
//                 }else{
//                     helper.makeToast("error", "Error", "Something went wrong when trying to delete the record, please check with your Salesforce Admin.")
//                 }
//             } else if (state === "ERROR") {
//                 var errors = response.getError();
//                 if (errors) {
//                     if (errors[0] && errors[0].message) {
//                         console.log("Error message: " +
//                             errors[0].message);
//                     }
//                 } else {
//                     console.log("Unknown error");
//                 }
//             }

//             this.stopLoading(component);
//         });
//         $A.enqueueAction(action);
//     },

//     stopLoading : function(component) {
//         var stopLoadingEvent = component.getEvent("stopLoadingEvent");
//         stopLoadingEvent.setParams({
//             "target": "stopLoading"
//         });
//         stopLoadingEvent.fire();
//     },

//     checkWriteAccess: function(component) {
//         let action = component.get('c.hasWriteAccess');

//         action.setParams({
//             recordId: component.get('v.recordId')
//         });

//         action.setCallback(this, function(response) {
//             let state = response.getState();

//             if (state === 'SUCCESS') {
//                 component.set('v.hasWriteAccess', response.getReturnValue());
//             } else if (state === "ERROR") {
//                 let errors = response.getError();
//                 if (errors) {
//                     if (errors[0] && errors[0].message) {
//                         console.error("Error message: " +
//                                       errors[0].message);
//                     }
//                 } else {
//                     console.log("Unknown error");
//                 }
//             }
//         });

//         $A.enqueueAction(action);
//     }

// })