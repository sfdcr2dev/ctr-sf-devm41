({
    loadCoin : function(component) {
        var action = component.get("c.getCoin");
        action.setParams({
            "url": 'https://qasapi-thaioilhub.thaioilgroup.com/api/km/getTopCoin?name='
        });

        
        action.setCallback(this, function(response){
            var state = response.getState();
            // alert(state);
            if (component.isValid() && state === "SUCCESS") {
                console.log('res---->' + response.getReturnValue());
                var x = JSON.parse(response.getReturnValue());
                
                //component.set("v.coin",x.message);
                if(x.status == 'Bad Request'){
                    //alert(x.message);
                    component.set("v.coin", x.message);
                }else{
                    var x = response.getReturnValue(); 
                    //alert(x);
                    component.set("v.coin", x);
                }
            }
        });
        $A.enqueueAction(action);
    }
})