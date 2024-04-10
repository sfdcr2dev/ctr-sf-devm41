({
	init : function(component, event, helper) {
        var recordId = component.get("v.recordId");
        var sobjecttype = component.get("v.sobjecttype");
        console.log('recordId:', recordId);
        console.log('sobjecttype:', sobjecttype);
	},
})