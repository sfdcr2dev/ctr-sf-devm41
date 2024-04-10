({
	
	doInit : function(component, event, helper) {
		
	},
    
    downloadManual: function(component, event, helper) {
        
        var ICRUserManual = component.get("v.ICRStaticResource");
        window.open(ICRUserManual, '_blank');
    },
})