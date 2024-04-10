({
    loadWeather : function(component) {
        var action = component.get("c.getWeather");
        var startPos;
        var lat = '13.361143';
        var lon = '100.984673';
        var geoSuccess = function(position) {
            startPos = position;
            lat = startPos.coords.latitude;
            lon = startPos.coords.longitude;
            console.log('latitude>>>'+lat);
        	console.log('longitude>>>'+lon);
            action.setParams({
                "lat": lat,
                "lon": lon
            });
            
            action.setCallback(this, function(response){
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS") {
                    console.log('res---->' + response.getReturnValue());
                    var x = JSON.parse(response.getReturnValue());
                    if(x.status == 'Bad Request'){
                        //alert(x.message);
                        component.set("v.weather", x.message);
                    }else{
                        var x = response.getReturnValue(); 
                        //alert(x);
                        component.set("v.weather", x + " °C");
                    }
                }
            });
            $A.enqueueAction(action);
        };        
        navigator.geolocation.getCurrentPosition(geoSuccess);
        
        //console.log('url---->' + url);
    }
})