({
	
	doInit : function(component, event, helper) {
    var recordId = component.get('v.recordId');
    var action = component.get('c.GetSalesOrg');
    action.setParams({'AccId' : recordId});
        
    action.setCallback(this,function(res){
    var state = res.getState();
    if(state==='SUCCESS'){
        $A.get('e.force:refreshView').fire();
        /*
        	var toastEvent = $A.get("e.force:showToast");
    		toastEvent.setParams({
        	"title": "Success!",
        	"message": "The record has been updated successfully.",
            "type": "success"
    		});
        	//var dismissActionPanel = $A.get("e.force:closeQuickAction");
            //dismissActionPanel.fire();
    		toastEvent.fire();
        	*/
        	window.setTimeout(
            $A.getCallback(function() {
                window.location.reload();
            }), 15000
        );
        
    	}
        else{
            var toastEvent = $A.get("e.force:showToast");
              		  	toastEvent.setParams({
                    	"title": "Error",
                    	"message": 'Please contact admin.',
                    	"type": "error"
                		});
            			var dismissActionPanel = $A.get("e.force:closeQuickAction");
            			dismissActionPanel.fire();
                		toastEvent.fire();
        }
    });
    $A.enqueueAction(action);
    }
})