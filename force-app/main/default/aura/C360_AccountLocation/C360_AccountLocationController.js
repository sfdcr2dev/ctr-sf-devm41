({
	initialize : function(component, event, helper) {
    var recordId = component.get('v.recordId');
    var action = component.get('c.getAccountLocation');
    action.setParams({'accountId' : recordId});
        
    action.setCallback(this,function(res){
    var state = res.getState();
    if(state==='SUCCESS'){
        console.log(res.getReturnValue());
        var acc = res.getReturnValue();
        component.set('v.accountLocation', [
            {
            location: {
                Latitude: acc.Location__Latitude__s,
                Longitude: acc.Location__Longitude__s
            },
    		title: acc.Name,
    		description: acc.Website
    		}
    	]);
    	component.set('v.zoomLevel', 15);
    	component.set('v.Latitude', acc.Location__Latitude__s);
    	component.set('v.Longitude', acc.Location__Longitude__s);
        component.set('v.ll', acc.Location__Latitude__s+','+acc.Location__Longitude__s);
        component.set('v.Location', 'false');
        if(acc.Location__Latitude__s != null){
            component.set('v.Location', 'true');}
    	}
    });
    $A.enqueueAction(action);
    },
})