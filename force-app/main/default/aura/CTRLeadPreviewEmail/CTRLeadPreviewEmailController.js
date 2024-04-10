({
	doInit: function (component, event, helper) {
       //alert(JSON.stringify(component.get('v.SObj')));
       //alert('lead obj'+ JSON.stringify(component.get('v.LeadObj').EmailPageAttachment__c));
       //alert(JSON.stringify(component.get('v.attachments'))); 
       var emailTo = component.get('v.SObj.EmailTo__c');
		console.log("Original Email To:", emailTo);
			if (emailTo && emailTo.includes(',')) {
    			var formattedEmails = emailTo.replace(/,/g, ",\n");
    			component.set('v.SObj.EmailTo__c', formattedEmails);
			}
    },
    handleClose : function(component, event, helper) {
        helper.closeModal(component);
    },
})