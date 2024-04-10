({
	 getStageNameHelper : function(component, event, helper) {     
         
         var action = component.get("c.getStageNamePath");         
         action.setParams({"recordId":component.get("v.recordId")});
         action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log('result', result)
                component.set('v.steps', result);
                component.set('v.currentStep', result[0].currentStep);
            }
        });        
         
        $A.enqueueAction(action); 
    },
    // Invokes the subscribe method on the empApi component
    subscribe : function(component, event, helper) {
        // Get the empApi component
        const empApi = component.find('empApi');
        // Get the channel from the input box
       
        const channel ='/topic/StatusFunctionalOverride';
        // Replay option to get new events
        const replayId = -1;
        // Subscribe to an event
        // console.log('empApi', empApi);
        empApi.subscribe(channel, replayId, $A.getCallback(eventReceived => {
            // console.log('eventReceived', eventReceived);
            // Process event (this is called each time we receive an event)
            var recordId = component.get('v.recordId') ;
            //console.log('recordId', recordId);
            //console.log('IDDDDDD', eventReceived.data.sobject.Id);
            //console.log('Check', recordId == eventReceived.data.sobject.Id);
            //console.log('Received event ', JSON.stringify(eventReceived));
            if(recordId == eventReceived.data.sobject.Id){
                console.log('refresing', eventReceived.data.sobject.Id);
                helper.getStageNameHelper(component, event, helper)
            }
        }))
        .then(subscription => {
            // Confirm that we have subscribed to the event channel.
            // We haven't received an event yet.
            // console.log('Subscribed to channel ', subscription.channel);
            // Save subscription to unsubscribe later
            component.set('v.subscription', subscription);
        });
    }
    
})