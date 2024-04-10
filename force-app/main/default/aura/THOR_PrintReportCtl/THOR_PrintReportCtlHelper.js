({/*
	handleStep : function(component, event) {
		// alert(component.get("v.eqccStepId"));
		var Id = component.get("v.eqccStepId");

		let action = component.get("c.getPrintStepId");
		action.setParams({
			stepId: Id
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			//alert(state);
			if (state === "SUCCESS") {
				var returnValue = response.getReturnValue();
				//alert('result='+ JSON.stringify(returnValue));
				// var formCode = returnValue['Form_Code__c'];
				// alert(formCode);
				// component.set("v.formCode", formCode);
				// var headerSheetName = returnValue['Header_Sheet__r']['Name'];
				// // var headerSheetName = returnValue['Header_Sheet__c'];
				// component.set("v.headerSheetName", headerSheetName);
				component.set("v.IdFromMyApproval", returnValue);
				this.handleNextStep(component,event);
			} else {}
		});
		$A.enqueueAction(action);
	},

	handleNextStep : function(component, event) {
		// alert(component.get("v.recordId"));
		var Id = component.get("v.IdFromMyApproval");

		let action = component.get("c.getPrintRecordId");
				action.setParams({
					eqccStepId: Id
				});
				action.setCallback(this, function (response) {
					let state = response.getState();
					// alert(state);
					if (state === "SUCCESS") {
						var returnValue = response.getReturnValue();
					
							// alert('result='+ JSON.stringify(returnValue));
							var formCode = returnValue['Form_Code__c'];
							formCode = formCode.replace(/-/g,'_');
							// alert(formCode);
							component.set("v.formCode", formCode);
							var headerSheetName = returnValue['Header_Sheet__r']['Name'];
							// var headerSheetName = returnValue['Header_Sheet__c'];
							component.set("v.headerSheetName", headerSheetName);
							$A.enqueueAction(component.get("c.handleOpenInNewWindow"));
						
					} 
				});
		$A.enqueueAction(action);
	},
    */
})