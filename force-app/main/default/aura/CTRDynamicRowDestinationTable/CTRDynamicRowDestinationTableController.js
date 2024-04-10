({
	AddNewRow : function(component, event, helper){
        component.getEvent("AddRowDestinationEvt").fire();
    },

    removeRow : function(component, event, helper){
        console.log('delete--index'+component.get("v.rowIndex"));
        
       component.getEvent("CTRDeleteRowDestinationEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }
})