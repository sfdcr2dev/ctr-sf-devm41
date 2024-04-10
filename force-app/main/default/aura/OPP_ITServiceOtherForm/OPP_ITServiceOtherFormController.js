({
	doInit: function (component, event, helper) {
		helper.getCase(component, event, helper);
		helper.getIsEmployee(component);
		helper.getDescribeFieldResult(component, 'Case', ['Creator_Email__c']);
	},

	closeModal: function (component, event, helper) {
		// event.preventDefault();
		if (component.get("v.formFactor") === "PHONE") {
			var navService = component.find("navService");
			navService.navigate(
				{
					type: "standard__webPage",
					attributes: {
						url: "/apex/previous_back",
					},
				},
				true
			);
		} else {
			var navigateToURL = $A.get("e.force:navigateToURL");
			navigateToURL.setParams({
				isredirect: true,
				url: "/lightning/n/DG_Service",
			});
			navigateToURL.fire();
		}
	},
	handleLoad: function (component, event, helper) {
		// console.log(JSON.parse(JSON.stringify(event.getParam("recordUi"))))
	},
	handleAutoApproval: function (component, event, helper) {
		component.set("v.autoApproval", true);
		component.find("utilityLwcButton").submit_click();
	},
	handleSubmit: function (component, event, helper) {
		event.preventDefault();
		component.set("v.isLoading", true);

		var fields = event.getParam("fields");
		// fields.Auto_Submit__c = component.get('v.autoApproval')

		component.find("otherForm").submit(fields);
	},
	handleSuccess: function (component, event, helper) {
		var params = event.getParams();
		var response = params.response;
		var caseId = response.id;

		component.set("v.isLoading", false);
		if (component.get("v.autoApproval")) {
			component.find("flowData").startFlow("autoSubmitRequest", [
				{
					name: "recordId",
					type: "String",
					value: caseId,
				},
			]);
			component.set("v.autoApproval", false);
		}

		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
			title: "Success!",
			message: $A.get(
				component.get("v.autoApproval")
					? "$Label.c.DG_Service_Auto_Submit_Success"
					: "$Label.c.DG_Service_Save_as_Draft"
			),
			duration: "5000",
			key: "info_alt",
			type: "success",
			mode: "pester",
		});
		toastEvent.fire();

		$A.enqueueAction(component.get("c.closeModal"));
	},
	handleError: function (component, event, helper) {
		component.set("v.isLoading", false);
	},
});