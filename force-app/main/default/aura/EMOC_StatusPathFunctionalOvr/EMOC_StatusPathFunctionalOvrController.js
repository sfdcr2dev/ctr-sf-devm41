({
    init:function(component,event,helper){
        helper.getStageNameHelper(component,event,helper);
        helper.subscribe(component, event, helper);
    }    
})