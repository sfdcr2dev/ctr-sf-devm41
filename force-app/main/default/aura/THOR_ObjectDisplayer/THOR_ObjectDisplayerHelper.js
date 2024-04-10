({
    tabChanged : function(component) {
        component.set("v.isLoading", true);
        let tabs = component.get("v.tabs");
        let index = component.get("v.selected");
        let titles = component.get("v.titles");

        for(let i=0; i< tabs.length; i++){
            if(index == i){
                tabs[i].set('v.isActive',true);
            }else{
                tabs[i].set('v.isActive',false);
            }
        }

        if (titles[index] == "Chatter"){
            component.set("v.isLoading", false);
        }

        var forEqcc = component.get("v.forEqcc");
        if (titles[index] == "Detail" && forEqcc){
            component.set("v.isLoading", false);
        }
    }
})