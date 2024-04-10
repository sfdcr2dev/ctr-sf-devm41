({
    showModalAction: function(component, event, helper){
        component.set("v.showModal", true);
    },

    closeModel: function(component, event, helper){
        component.set("v.showModal", false);
    },

    stopPropagation: function(component, event){
        event.preventDefault();
        event.stopPropagation();
    }
})