({
	getLink : function(component, event, helper) 
	{
        var spFolder = component.get('v.spFolder');
        var recordId = component.get('v.recordId');
        console.log(spFolder);
        var action = component.get('c.getLink');
        action.setParams({'folderName' : spFolder , 'recordId' : recordId});
            action.setCallback(this,function(res)
            {
                var state = res.getState();
                if(state==='SUCCESS')
                {
                    var result = res.getReturnValue();
                    console.log(result);

                        component.set('v.SharePointList', result);
                        console.log('2'+result);

                        component.set("v.loaded", true);

                    //component.set('v.spPath', res.getReturnValue());
                }
            });
            $A.enqueueAction(action);
    },
})