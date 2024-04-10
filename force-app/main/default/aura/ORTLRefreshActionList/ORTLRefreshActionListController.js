({
    doInit: function (component, event, helper) {
        setTimeout(function() {
        	$A.get('e.force:refreshView').fire();
            console.log('Refresh');
        }, 2500);
    }
})