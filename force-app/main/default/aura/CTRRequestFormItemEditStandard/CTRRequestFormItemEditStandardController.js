({
    doInit : function(component, event, helper) 
    {
        console.log('doinit standard');
                    
        /*var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": component.get("v.recordId")
        });
        editRecordEvent.fire();*/
                                        
               
    },
    
    onInit : function(component, event, helper) {
        console.log('oninit standard');

    },

    save : function(component, event, helper) {

        component.set('v.showSpinner',true);
        try {
				component.find("edit").get("e.recordSave").fire();
        		console.log(component.get("v.rId"));
                component.set('v.showSpinner',false);
        }
          catch (e) {
            console.log(e);
                      component.set('v.showSpinner',false);

          }

    },
    
    handleCancel : function(component, event, helper) 
    {
        var navEvt = $A.get("e.force:navigateToSObject");
             navEvt.setParams({
             "recordId": component.get('v.recordId'),
             "slideDevName": "related"
             });
             navEvt.fire();

        
        var navigateToURL= '/'+component.get('v.recordId');
    	var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                  "url": navigateToURL
                 });
                 //urlEvent.fire();
    },
    
    onSaveSuccess: function(component, event, helper) 
    {
        console.log('in c.onSaveSuccess');
          //var recordId = cmp.get('v.recordId');
          //$A.get("e.force:navigateToURL").setParams({
            //"url": "/" + recordId,
            //isredirect: true
          //}).fire();
          //
                component.set('v.showSpinner',false);

        var nav = component.find("navService"); 


        var pageReference = { 

            "type": "standard__recordPage", 

            "attributes": {

                "recordId": component.get("v.recordId"),

                "actionName": "view"

            }

        } 

        var URL = nav.navigate(pageReference);
    }
    
})