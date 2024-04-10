({
	handleClick : function(component, event, helper) {
		// alert('eqccstepId '+ component.get("v.recordId"));
		var Id = component.get("v.recordId");
		//alert('----ID---'+Id);

		let action = component.get("c.getPrintRecordId");
		action.setParams({
			recordId: Id
		});
		action.setCallback(this, function (response) {
			let state = response.getState();
			// alert(state);
			if (state === "SUCCESS") {
				var returnValue = response.getReturnValue();
				if(returnValue == null){ 
					//helper.handleStep(component, event)
				}else{
					// alert('result='+ JSON.stringify(returnValue));
					var formCode = returnValue['Form_Code__c'];
					formCode = formCode.replace(/-/g,'_');
					// alert(formCode);
					component.set("v.formCode", formCode);
					var headerSheetName = returnValue['Header_Sheet__r']['Name'];
					
					// alert(headerSheetName);
					// var headerSheetName = returnValue['Header_Sheet__c'];
					component.set("v.headerSheetName", headerSheetName);
					$A.enqueueAction(component.get("c.handleOpenInNewWindow"));
				}
				
			}  else if(state == "ERROR"){
                var errors = response.getError();                       
                    component.set("v.showErrors",true);
                    component.set("v.errorMessage",errors[0].message);
                alert(JSON.stringify(errors));
            }
		
		});
		$A.enqueueAction(action);
	},
	
		//Open URL in New Browser Tab
		handleOpenInNewWindow : function(component, event, helper) {
			var formCode = component.get("v.formCode");
			var headerSheetName = component.get("v.headerSheetName");
			// https://topterminal.thaioilgroup.com:8443/[EQCC Checked Sheet]?EQCC_id=[Header Sheet Name] 
			window.open("https://topterminal.thaioilgroup.com:8443/" + formCode +"?EQCC_id="+ headerSheetName,'_blank');
		},
		
		//Open URL in New Browser Tab With Record Id
		// handleOpenNewWindowWithRecordId : function(component, event, helper) {
		// 	var recordId = component.get('v.recordId');
		// 	window.open('/' + recordId,'_blank');
		// }
	
})