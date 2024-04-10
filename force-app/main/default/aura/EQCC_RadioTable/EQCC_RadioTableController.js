({
    handleClick : function(component, event, helper) {
        let id = event.getSource().get("v.id");
        let inputs = component.get("v.fieldInputs");
        inputs[0].inputs.forEach(element => {
            element.values.forEach(aValue => {
                if(aValue.keyHeader === 'GroupTitle'){
                    aValue.group.forEach(element => {
                        if(element.id === id){
                            aValue.group.forEach(aElement => {
                                aElement.value = false;
                            });
                            element.value = true;
                        }
                    });
                }
            });
        });
        component.set("v.fieldInputs", inputs);
    },
    save: function(component) {},
   
})