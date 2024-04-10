({
    initialize : function(component, event, helper) {
        //var recordId = component.get('v.recordId');
        //var action = component.get('c.getAccountInfo');

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
                    if(result)
                    {
                        component.set('v.SharePointList', result);
                        component.set('v.loadedButtonURL', true)
                    }
                        //component.set('v.SharePointList', result);
                        console.log('2'+component.get('v.SharePointList'));

                        component.set("v.loaded", true);

                    //component.set('v.spPath', res.getReturnValue());
                }
            });
            $A.enqueueAction(action);
        //helper.getLink(component, event, helper);
    },
    linkUrl : function(component, event, helper) 
    {
        var element = event.getSource();
		var mLink = element.get("v.value");
        var spPath = component.get('v.spPath');
        window.open(mLink);
    },
})