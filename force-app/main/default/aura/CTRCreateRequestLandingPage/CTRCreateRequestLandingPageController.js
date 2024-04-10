({
	doInit: function (component, event, helper) {
		console.log('recordId: ', component.get('v.recordId'));
		component.set("v.showLoading", false);
	},

	handleChangeBU: function(component, event, helper) {
		const selectedBU = event.getParams().value;
		component.set('v.selectedBU', selectedBU);
		// const recordTypeList = helper.recordTypeList;
		// console.log('recordTypeList -----', recordTypeList);
		// const filteredRecordTypeList = recordTypeList.filter(function(item) {
		// 	return helper.recordType[selectedBU].includes(item.mDeveloperName);
		// });
		// component.set('v.recordTypeList', filteredRecordTypeList);
		component.set('v.selectRecordTypeId', null);
		component.set('v.isTX', false);
		component.set('v.isLABIX', false);
		component.set('v.isTOP', false);
		if (selectedBU) {
			if (selectedBU == 'TX') {
				component.set('v.isTX', true);
			}
			if (selectedBU == 'LABIX') {
				component.set('v.isLABIX', true);
			}
			if (selectedBU == 'TOP') {
				component.set('v.isTOP', true);
			}
		}
		helper.getAllRecordTypeList(component);
	},

	handleClickRadio: function (component, event, helper) {
		const target = event.currentTarget;
		const sfid = target.dataset.sfid;
		console.log('sfid:' + sfid);
		component.set('v.selectRecordTypeId', sfid);
	},

	handleCancel: function (component, event, helper) {
		helper.closeModal(component);
	},

	handleNext: function (component, event, helper) {
		// var recordId = component.get('v.recordId');
		var recordId = component.get('v.recordId');
		var selectedRecordTypeId = component.get('v.selectRecordTypeId');
		console.log('selectedRecordTypeId:' + selectedRecordTypeId);

		//Call Other Component here
		//helper.toastEvent('success','Landing page In Progress development - Select RecordType page done:'+selectedRecordTypeId, 'success');
		//helper.closeModal(component);

		const step = component.get('v.step');
		console.log('step -----', step);
		if(step === 'RecordType') {
			helper.createComponent(component);
		} else {
			component.set('v.step', 'RecordType');
		}
	},

	handleSave: function (component, event, helper) {
		if (helper.newRequestComponent) {
			component.set('v.displayWarning', false);
			const p1 = helper.newRequestComponent.saveRequest();
			p1.then(
				$A.getCallback(function(result) {
					console.log('[handleSave] result -----', result);
					if(!$A.util.isEmpty(result.recordId)) {
						console.log("Resolve: handleSave");
						helper.closeModal(component);
						var navEvt = $A.get("e.force:navigateToSObject");
						navEvt.setParams({
							"recordId": result.recordId,
							"slideDevName": "detail"
						});
						navEvt.fire();
					} else {
						console.log("Reject: handleSave");
						component.set('v.warningMessage', result.errorMessage);
						component.set('v.displayWarning', true);
					}
				}),
				$A.getCallback(function(errors) {
					console.error("Reject: handleSave");
					console.error(errors);
				})
			).catch(
				$A.getCallback(function(errors) {
					console.error("Error: handleSave");
					console.error(errors);
				})
			);
		}
	},
})