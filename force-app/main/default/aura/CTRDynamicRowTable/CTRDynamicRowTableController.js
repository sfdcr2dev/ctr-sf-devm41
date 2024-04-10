({
	AddNewRow : function(component, event, helper){
        component.getEvent("AddRowEvt").fire();
    },

    removeRow : function(component, event, helper){
        console.log('delete--index'+component.get("v.rowIndex"));
        
       component.getEvent("CTRDeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    },

    onChangePerc : function(component, event, helper) {
        var myEle = component.find("percenShareHolder");
        console.log("Element:" +myEle);
        
        /*var myAttri = component.find("percenShareHolder").get("v.value");
        console.log("Value:"+ myAttri);
        
        var myAttriMin = component.find("percenShareHolder").get("v.min");
        console.log("Min:"+myAttriMin);       
        component.find("percenShareHolder").set("v.min", parseInt(myAttriMin)+1);
        myAttriMin = component.find("percenShareHolder").get("v.min");
        console.log("MinAfter:"+myAttriMin);       
        
        var myAttriMax = component.find("percenShareHolder").get("v.max");
        console.log("Mzx:"+myAttriMax);
        component.find("percenShareHolder").set("v.max", parseInt(myAttriMax)+1);
        myAttriMax = component.find("percenShareHolder").get("v.max");
        console.log("MaxAfter:"+myAttriMax);  */
        
    
    }
})